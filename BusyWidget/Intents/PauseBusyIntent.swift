import Foundation
import AppIntents
import WidgetKit

struct PauseBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "PauseBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    func perform() async throws -> some IntentResult {
        fatalError()
    }
}
