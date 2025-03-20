import Foundation

struct Attempt: Codable {
    var name: String
    var timestamp: Date

    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}

final class ShieldAttemptService: Sendable {
    static let shared = ShieldAttemptService()

    private var key: String { "access_attempts" }
    private var delay: TimeInterval { 0.25 }

    private var attempts: [Attempt] {
        get {
            let decoder = JSONDecoder()
            guard
                let data = UserDefaults.group.data(forKey: key),
                let decoded = try? decoder.decode([Attempt].self, from: data)
            else { return [] }
            return decoded
        }
        set {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(newValue) else { return }
            UserDefaults.group.set(data, forKey: key)
        }
    }

    private init() {
    }

    func add(by name: String) -> Int {
        var attempts = self.attempts.filter { $0.timestamp >= .today }

        let prevAttempt = attempts.last { $0.name == name }
        let attempt = Attempt(name: name, timestamp: .now)

        if
            let prevAttempt = prevAttempt,
            attempt.timestamp.timeIntervalSince(prevAttempt.timestamp) < delay
        {
            return attempts.count(where: { $0.name == name })
        }

        attempts.append(attempt)
        self.attempts = attempts
        return attempts.count(where: { $0.name == name })
    }
}

fileprivate extension Date {
    static var today: Date {
        Calendar.current.startOfDay(for: .now)
    }
}
