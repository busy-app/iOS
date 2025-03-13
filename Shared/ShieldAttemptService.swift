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

    func getCount(by name: String) -> Int {
        let startOfToday = Calendar.current.startOfDay(for: .now)

        let predicate = #Predicate<Attempt> {
            $0.name == name && $0.timestamp >= startOfToday
        }
        let descriptor = FetchDescriptor<Attempt>(predicate: predicate)
        return (try? context.fetchCount(descriptor)) ?? 0
    }

    func getAllCount() -> Int {
        let startOfToday = Calendar.current.startOfDay(for: .now)

        let predicate = #Predicate<Attempt> {
            $0.timestamp >= startOfToday
        }

        let descriptor = FetchDescriptor<Attempt>(predicate: predicate)
        return (try? context.fetchCount(descriptor)) ?? 0
    }
}
