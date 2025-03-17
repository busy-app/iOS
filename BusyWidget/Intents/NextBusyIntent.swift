import Foundation
import AppIntents
import WidgetKit

struct NextBusyIntent: LiveActivityIntent {
    static var title: LocalizedStringResource { "NextBusy" }

    static var openAppWhenRun: Bool { false }

    init() {
    }

    func perform() async throws -> some IntentResult {
        fatalError()
    }
}
