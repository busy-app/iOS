import Foundation
import AppIntents
import WidgetKit

struct PauseBusyIntent: LiveActivityIntent {
    static var title: LocalizedStringResource { "PauseBusy" }

    static var openAppWhenRun: Bool { false }

    init() {
    }

    func perform() async throws -> some IntentResult {
        fatalError()
    }
}
