import Foundation
import AppIntents
import WidgetKit

struct NextBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "NextBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    func perform() async throws -> some IntentResult {
        fatalError()
    }
}
