import SwiftUI
import Combine

struct LightItUpView: View {
    @State private var activeCards: Set<Int> = [0]
    @State private var score = 0
    @State private var timeRemaining = 60
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
    
    

    private var cardCount: Int {
        switch level {
        case 1:
            return 3
        case 2:
            return 4
        case 3:
            return 6
        default:
            return 9
        }
    }

    private var columns: [GridItem] {
        switch level {
        case 1:
            return Array(repeating: GridItem(.flexible()), count: 3)

        case 2:
            return Array(repeating: GridItem(.flexible()), count: 2)

        case 3:
            return Array(repeating: GridItem(.flexible()), count: 3)

        default:
            return Array(repeating: GridItem(.flexible()), count: 3)
        }
    }

    private var lightDuration: Double {
        switch level {
        case 1:
            return 1.5
        case 2:
            return 1.2
        case 3:
            return 1.0
        default:
            return 0.8
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
                                        activeCards.contains(index)
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
            generateActiveCards()
            startCardTimer()
        }
    }
    
    private func handleCardTap(_ index: Int) {

        guard !gameOver else {
            return
        }

        if activeCards.contains(index) {

            score += 1

            generateActiveCards()

            startCardTimer()

        } else {

            score = max(0, score - 1)

        }
    }
    
    private func generateActiveCards() {

        if level == 4 {

            while true {

                let first = Int.random(in: 0..<cardCount)
                let second = Int.random(in: 0..<cardCount)

                if first != second {

                    activeCards = [first, second]
                    break

                }
            }

        } else {

            activeCards = [Int.random(in: 0..<cardCount)]

        }

    }
    
    private func startCardTimer() {
        let currentCards = activeCards
        let currentToken = UUID()

        cardTimerToken = currentToken

        DispatchQueue.main.asyncAfter(
            deadline: .now() + lightDuration
        ) {
            guard !gameOver,
                  cardTimerToken == currentToken else {
                return
            }

            if activeCards == currentCards {
                score = max(0, score - 1)
               generateActiveCards()
                startCardTimer()
            }
        }
    }
    
    private func updateLevel() {
        let newLevel: Int

        if timeRemaining > 45 {
            newLevel = 1
        } else if timeRemaining > 30 {
            newLevel = 2
        } else if timeRemaining > 15 {
            newLevel = 3
        } else {
            newLevel = 4
        }

        if newLevel != level {
            level = newLevel
            generateActiveCards()
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
        timeRemaining = 60
        gameOver = false
        level = 1
        generateActiveCards()
        startCardTimer()
    }

}

#Preview {
    LightItUpView()
}
