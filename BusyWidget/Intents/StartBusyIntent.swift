import Foundation
import AppIntents
import WidgetKit

struct StartBusyIntent: LiveActivityIntent {
    static var title: LocalizedStringResource { "StartBusy" }

    static var openAppWhenRun: Bool { false }

    init() {
    }

    func perform() async throws -> some IntentResult {
        fatalError()
    }
}
