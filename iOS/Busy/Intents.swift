import Foundation
import AppIntents
import WidgetKit

struct StopBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "StopBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    func perform() async throws -> some IntentResult {
        await Timer.shared.stop()
        return .result()
    }
}
