import SwiftUI
import Combine

struct LightItUpView: View {
    @State private var activeCard = 0
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var gameOver = false
    @State private var level = 1
    @State private var cardTimerToken = UUID()
    @AppStorage("lightItUpHighScore")
    
    private var highScore = 0
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    
    private var gridSize: Int {
        switch level {
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 4
        }
    }

    private var cardCount: Int {
        gridSize * gridSize
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible()),
            count: gridSize
        )
    }

    private var lightDuration: Double {
        switch level {
        case 1:
            return 1.5
        case 2:
            return 1.0
        default:
            return 0.7
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if gameOver {
                gameOverView
            } else {
                VStack(spacing: 30) {
                    
                    Text("Light It Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("Score: \(score)")
                        .font(.title2)
                        .foregroundStyle(.white)
                    
                    Text("High Score: \(highScore)")
                        .font(.title3)
                        .foregroundStyle(.green)
                    
                    Text("Time: \(timeRemaining)")
                        .font(.title2)
                        .foregroundStyle(.white)
                    
                    Text("Level: \(level)")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        ForEach(0..<cardCount, id: \.self) { index in
                            
                            Button {
                                handleCardTap(index)
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        index == activeCard
                                        ? Color.yellow
                                        : Color.gray
                                    )
                                    .frame(height: 100)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                }
                
                .padding(.top, 50)
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                updateLevel()
            } else {
                gameOver = true
                
                if score > highScore {
                    highScore = score
                }
            }
        }
        .onAppear {
            startCardTimer()
        }
    }
    
    private func handleCardTap(_ index: Int) {
        guard !gameOver else {
            return
        }
        if index == activeCard {
            score += 1
            activeCard = Int.random(in: 0..<cardCount)
            startCardTimer()
        } else {
            score = max(0, score - 1)
        }
        
    }
    
    private func startCardTimer() {
        let currentCard = activeCard
        let currentToken = UUID()

        cardTimerToken = currentToken

        DispatchQueue.main.asyncAfter(
            deadline: .now() + lightDuration
        ) {
            guard !gameOver,
                  cardTimerToken == currentToken else {
                return
            }

            if activeCard == currentCard {
                score = max(0, score - 1)
                activeCard = Int.random(in: 0..<cardCount)
                startCardTimer()
            }
        }
    }
    private func updateLevel() {
        let newLevel: Int

        if timeRemaining > 20 {
            newLevel = 1
        } else if timeRemaining > 10 {
            newLevel = 2
        } else {
            newLevel = 3
        }

        if newLevel != level {
            level = newLevel
            activeCard = Int.random(in: 0..<cardCount)
            startCardTimer()
        }
    }
    private var gameOverView: some View {
        VStack(spacing: 25) {
            
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.yellow)
            
            Text("Final Score: \(score)")
                .font(.title2)
                .foregroundStyle(.white)
            
            Text("High Score: \(highScore)")
                .font(.title3)
                .foregroundStyle(.green)
            
            Button("Play Again") {
                restartGame()
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .padding()
            .background(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func restartGame() {
        score = 0
        timeRemaining = 30
        gameOver = false
        level = 1
        activeCard = Int.random(in: 0..<cardCount)
        startCardTimer()
    }

}

#Preview {
    LightItUpView()
}
