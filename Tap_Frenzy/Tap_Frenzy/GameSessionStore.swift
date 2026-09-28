import Foundation

final class GameSessionStore {

    static let shared = GameSessionStore()

    private let key = "gameSessions"

    private init() { }

    func save(_ session: GameSession) {
        var sessions = loadSessions()
        sessions.append(session)

        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadSessions() -> [GameSession] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let sessions = try? JSONDecoder().decode([GameSession].self, from: data)
        else {
            return []
        }

        return sessions
    }

    func clearSessions() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
