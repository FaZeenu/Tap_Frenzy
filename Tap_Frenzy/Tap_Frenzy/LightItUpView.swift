import SwiftUI
import Combine

struct LightItUpView: View {
    @State private var activeCard = 0
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var gameOver = false
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                    
                    Text("Time: \(timeRemaining)")
                        .font(.title2)
                        .foregroundStyle(.white)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        ForEach(0..<9, id: \.self) { index in
                            
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
            } else {
                gameOver = true
            }
        }
    }
    
    private func handleCardTap(_ index: Int) {
        guard !gameOver else {
            return
        }
        if index == activeCard {
            score += 1
            activeCard = Int.random(in: 0..<9)
        } else {
            score = max(0, score - 1)
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
        activeCard = Int.random(in: 0..<9)
    }

}

#Preview {
    LightItUpView()
}
