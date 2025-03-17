import Foundation
import AppIntents
import WidgetKit

struct NextBusyIntent: LiveActivityIntent {
    static var title: LocalizedStringResource { "NextBusy" }

    static var openAppWhenRun: Bool { false }

    init() {
    }

    @MainActor func perform() async throws -> some IntentResult {
        guard let busy = BusyState.Holder.shared.current else {
            return .result()
        }

        busy.next()
        busy.start()
        return .result()
    }
}
