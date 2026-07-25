import SwiftUI
import Combine

struct Card: Identifiable, Equatable {
    let id: Int
    var isLit: Bool
}

enum GameLevel {
    case level1
    case level2
    case level3
    case level4
}

struct LightItUpView: View {
    @State private var cards: [Card] = []
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var gameOver = false
    @State private var level: GameLevel = .level1
    @State private var cardTimerToken = UUID()
    @State private var hasSavedSession = false
    @AppStorage("lightItUpHighScore")
    private var highScore = 0
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    

    private var cardCount: Int {
        switch level {
        case .level1:
            return 3
        case .level2:
            return 4
        case .level3:
            return 6
        case .level4:
            return 9
        }
    }

    private var columns: [GridItem] {
        switch level {
        case .level1:
            return Array(
                repeating: GridItem(.flexible()),
                count: 3
            )

        case .level2:
            return Array(
                repeating: GridItem(.flexible()),
                count: 2
            )

        case .level3:
            return Array(
                repeating: GridItem(.flexible()),
                count: 3
            )

        case .level4:
            return Array(
                repeating: GridItem(.flexible()),
                count: 3
            )
        }
    }

    private var lightDuration: Double {
        switch level {
        case .level1:
            return 1.5
        case .level2:
            return 1.2
        case .level3:
            return 1.0
        case .level4:
            return 0.8
        }
    }
    
    private var levelNumber: Int {
        switch level {
        case .level1:
            return 1
        case .level2:
            return 2
        case .level3:
            return 3
        case .level4:
            return 4
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
                    
                    Text("Level: \(levelNumber)")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        ForEach(cards) { card in

                            Button {
                                handleCardTap(card.id)
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        card.isLit
                                        ? Color.yellow
                                        : Color.gray
                                    )
                                    .frame(height: 100)
                                    .scaleEffect(
                                        card.isLit ? 1.08 : 1.0
                                    )
                                    .animation(
                                        .easeInOut(duration: 0.2),
                                        value: cards
                                    )
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

                saveGameSession()
            }
        }
        .onAppear {
            generateActiveCards()
            startCardTimer()
        }
    }
    
    private func saveGameSession() {
        guard hasSavedSession == false else {
            return
        }

        let session = GameSession(
            mode: .lightItUp,
            score: score,
            timestamp: Date(),
            latitude: 0.0,
            longitude: 0.0
        )

        GameSessionStore.shared.save(session)
        hasSavedSession = true
    }
    
    private func handleCardTap(_ cardID: Int) {
        guard !gameOver else {
            return
        }

        let wasCorrectTap =
            cards.first(where: { $0.id == cardID })?.isLit == true

        withAnimation(.easeInOut(duration: 0.2)) {
            if wasCorrectTap {
                score += 1
                generateActiveCards()
            } else {
                score = max(0, score - 1)
            }
        }

        if wasCorrectTap {
            startCardTimer()
        }
    }
    
    private func generateActiveCards() {
        var litCardIDs: Set<Int> = []

        if level == .level4 {
            while litCardIDs.count < 2 {
                let randomID = Int.random(in: 0..<cardCount)
                litCardIDs.insert(randomID)
            }
        } else {
            let randomID = Int.random(in: 0..<cardCount)
            litCardIDs.insert(randomID)
        }

        cards = (0..<cardCount).map { index in
            Card(
                id: index,
                isLit: litCardIDs.contains(index)
            )
        }
    }
    
    private var currentLitCardIDs: Set<Int> {
        Set(
            cards
                .filter { $0.isLit }
                .map { $0.id }
        )
    }
    
    private func startCardTimer() {
        let previousLitCardIDs = currentLitCardIDs
        let currentToken = UUID()

        cardTimerToken = currentToken

        DispatchQueue.main.asyncAfter(
            deadline: .now() + lightDuration
        ) {
            guard !gameOver,
                  cardTimerToken == currentToken else {
                return
            }

            if currentLitCardIDs == previousLitCardIDs {
                withAnimation(.easeInOut(duration: 0.2)) {
                    score = max(0, score - 1)
                    generateActiveCards()
                }

                startCardTimer()
            }
        }
    }
    
    private func updateLevel() {
        let newLevel: GameLevel

        if timeRemaining > 45 {
            newLevel = .level1
        } else if timeRemaining > 30 {
            newLevel = .level2
        } else if timeRemaining > 15 {
            newLevel = .level3
        } else {
            newLevel = .level4
        }

        if newLevel != level {
            withAnimation(.easeInOut(duration: 0.3)) {
                level = newLevel
                generateActiveCards()
            }

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
        level = .level1
        hasSavedSession = false
        generateActiveCards()
        startCardTimer()
    }
}

#Preview {
    LightItUpView()
}
