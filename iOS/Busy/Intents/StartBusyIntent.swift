import Foundation
import AppIntents
import WidgetKit

struct StartBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "StartBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    @MainActor func perform() async throws -> some IntentResult {
        guard let busy = BusyState.Holder.shared.current else {
            return .result()
        }

        busy.start()
        return .result()
    }
}
