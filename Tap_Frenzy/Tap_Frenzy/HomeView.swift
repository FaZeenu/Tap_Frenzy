import SwiftUI

struct HomeView: View {

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [
                        Color.purple,
                        Color.blue,
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {

                    Spacer()

                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.yellow)

                    Text("Game Hub")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Choose your challenge")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.8))

                    Spacer()

                    NavigationLink {
                        ContentView()
                    } label: {

                        GameCard(
                            icon: "bolt.fill",
                            title: "Tap Frenzy",
                            subtitle: "Tap as fast as you can",
                            color: .orange
                        )
                    }

                    NavigationLink {
                        LightItUpView()
                    } label: {

                        GameCard(
                            icon: "lightbulb.fill",
                            title: "Light It Up",
                            subtitle: "Test your reflexes",
                            color: .yellow
                        )
                    }
                    
                    NavigationLink {
                        QuizRushView()
                    } label: {
                        GameCard(
                            icon: "questionmark.circle.fill",
                            title: "Quiz Rush",
                            subtitle: "Test your trivia knowledge",
                            color: .orange
                        )
                    }

                    Spacer()

                    Text("🎯 Can you beat your High Score?")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.headline)

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct GameCard: View {

    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {

        HStack(spacing: 20) {

            Image(systemName: icon)
                .font(.system(size: 35))
                .foregroundStyle(color)
                .frame(width: 70, height: 70)
                .background(.white.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(subtitle)
                    .foregroundStyle(.white.opacity(0.75))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.7))

        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 10)
    }
}

#Preview {
    HomeView()
}
