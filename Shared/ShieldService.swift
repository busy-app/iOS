import ManagedSettings

import Foundation

final class ShieldService: Sendable {
    static let shared = ShieldService()

    private var attemptsKey: String { "access_attempts" }
    private var attemptsDelay: Double { 0.5 }

    private var attempts: [Attempt] {
        get {
            let decoder = JSONDecoder()
            guard
                let data = UserDefaults.group.data(forKey: attemptsKey),
                let decoded = try? decoder.decode([Attempt].self, from: data)
            else { return [] }
            return decoded
        }
        set {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(newValue) else { return }
            UserDefaults.group.set(data, forKey: attemptsKey)
        }
    }


    private func cleanupOld() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        attempts = attempts.filter { $0.timestamp >= today }
    }

    func addAttempt(name: String) {
        cleanupOld()
        guard let attempt = getNewAttempt(name: name) else { return }

        var current = attempts
        current.append(attempt)
        attempts = current
    }

    private func getNewAttempt(name: String) -> Attempt? {
        let newTime = Date.now
        let newAttempt = Attempt(name: name, timestamp: newTime)

        let lastAttempt = attempts.filter { $0.name == name }.last

        if let lastAttempt = lastAttempt {
            let lastTime = lastAttempt.timestamp

            // Workaround for the double open issue
            if newTime.timeIntervalSince(lastTime) < attemptsDelay {
                return nil
            }
        }
        return newAttempt
    }

    func getAttempt(name: String) -> Int {
        cleanupOld()
        return attempts.filter { $0.name == name }.count
    }

    func getAll() -> Int {
        cleanupOld()
        return attempts.count
    }
}

struct Attempt: Codable {
    let name: String
    let timestamp: Date
}
