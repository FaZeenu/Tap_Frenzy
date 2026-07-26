import SwiftUI
import Charts

struct StatsTabView: View {

    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationStack {

            List {

                Section("Overall Statistics") {

                    statRow(
                        title: "Total Games",
                        value: "\(viewModel.totalGames)"
                    )

                    statRow(
                        title: "Highest Score",
                        value: "\(viewModel.highestScore)"
                    )

                    statRow(
                        title: "Average Score",
                        value: String(format: "%.1f", viewModel.averageScore)
                    )
                }
                
                Section("Games by Mode") {

                    Chart(viewModel.gamesPerMode, id: \.mode) { item in

                        BarMark(
                            x: .value("Game", item.mode),
                            y: .value("Played", item.count)
                        )
                    }
                    .frame(height: 220)
                }

                Section("Recent Games") {

                    if viewModel.recentSessions.isEmpty {

                        Text("No games played yet.")
                            .foregroundStyle(.secondary)

                    } else {

                        ForEach(viewModel.recentSessions) { session in

                            VStack(alignment: .leading) {

                                Text(session.mode.rawValue)
                                    .font(.headline)

                                Text("Score: \(session.score)")
                                    .foregroundStyle(.secondary)

                                Text(session.timestamp.formatted())
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
            .onAppear {
                viewModel.loadSessions()
            }
        }
    }

    private func statRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)

            Spacer()

            Text(value)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    StatsTabView()
}
