import Foundation
import AppIntents
import WidgetKit

struct StartBusyIntent: LiveActivityIntent {
    static var title: LocalizedStringResource { "StartBusy" }

    static var openAppWhenRun: Bool { false }

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
