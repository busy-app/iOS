import SwiftData
import Foundation

@Model
final class Attempt {
    var id: UUID
    var name: String
    var timestamp: Date

    init(name: String, timestamp: Date) {
        self.id = UUID()
        self.name = name
        self.timestamp = timestamp
    }
}

final class ShieldAttemptService: @unchecked Sendable {
    static let shared = ShieldAttemptService()
    private let container: ModelContainer
    private let context: ModelContext

    private init() {
        container = try! ModelContainer(for: Attempt.self)
        context = ModelContext(container)
    }

    func add(by name: String) {
        let attempt = Attempt(name: name, timestamp: .now)
        context.insert(attempt)
        try? context.save()
    }

    func count(
        for name: String? = nil,
        since date: Date? = nil
    ) -> Int {
        let predicate = #Predicate<Attempt> { attempt in
            (name == nil || attempt.name == name!) &&
            (date == nil || attempt.timestamp >= date!)
        }

        let descriptor = FetchDescriptor<Attempt>(predicate: predicate)
        return (try? context.fetchCount(descriptor)) ?? 0
    }
}
