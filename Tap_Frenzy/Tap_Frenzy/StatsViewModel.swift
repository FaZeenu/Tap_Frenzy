import Foundation
import Combine

@MainActor
final class StatsViewModel: ObservableObject {

    @Published var sessions: [GameSession] = []

    var totalGames: Int {
        sessions.count
    }

    var highestScore: Int {
        sessions.map(\.score).max() ?? 0
    }

    var averageScore: Double {
        guard sessions.isEmpty == false else {
            return 0
        }

        let totalScore = sessions.reduce(0) { result, session in
            result + session.score
        }

        return Double(totalScore) / Double(sessions.count)
    }

    var recentSessions: [GameSession] {
        Array(
            sessions
                .sorted { $0.timestamp > $1.timestamp }
                .prefix(5)
        )
    }
    
    var gamesPerMode: [(mode: String, count: Int)] {

        let grouped = Dictionary(
            grouping: sessions,
            by: { $0.mode.rawValue }
        )

        return grouped.map { key, value in
            (mode: key, count: value.count)
        }
        .sorted { $0.mode < $1.mode }
    }

    func loadSessions() {
        sessions = GameSessionStore.shared.loadSessions()
    }
}
