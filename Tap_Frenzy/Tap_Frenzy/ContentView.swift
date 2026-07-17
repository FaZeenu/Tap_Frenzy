import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Tap Frenzy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Time: 10")
                    .font(.title2)
                    .foregroundStyle(.white)

                Text("Score: 0")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Button {
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
    }
}

#Preview {
    ContentView()
}
