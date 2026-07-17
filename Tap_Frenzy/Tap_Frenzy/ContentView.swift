import SwiftUI
import Combine

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 10
    
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

                Text("Score: \(score)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

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
            }
            .padding()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}

#Preview {
    ContentView()
}
