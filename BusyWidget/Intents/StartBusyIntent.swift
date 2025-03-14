import Foundation
import AppIntents
import WidgetKit

struct StartBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "StartBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    func perform() async throws -> some IntentResult {
        fatalError()
    }
}
