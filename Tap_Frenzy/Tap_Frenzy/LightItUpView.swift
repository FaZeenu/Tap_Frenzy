import SwiftUI

struct LightItUpView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 30) {

                Text("Light It Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Score: 0")
                    .font(.title2)
                    .foregroundStyle(.white)

                Text("Time: 30")
                    .font(.title2)
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    LightItUpView()
}
