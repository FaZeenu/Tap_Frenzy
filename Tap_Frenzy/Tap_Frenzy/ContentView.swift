import SwiftUI
import Combine

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var highScore = 0
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Tap Frenzy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Time: \(timeRemaining)")
                    .font(.title2)
                    .foregroundStyle(.white)

                Text("High Score: \(highScore)")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Score: \(score)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                if timeRemaining > 0 {
                    Button {
                        score += 1
                    } label: {
                        Text("TAP!")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.blue)
                            .frame(width: 220, height: 220)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                } else {
                    Text("Game Over!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)

                    Text("Final Score: \(score)")
                        .font(.title2)
                        .foregroundStyle(.white)

                    Button("Play Again") {
                        score = 0
                        timeRemaining = 10
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            if timeRemaining == 0 && score > highScore {
                    highScore = score
                }
        }
    }
}

#Preview {
    ContentView()
}
