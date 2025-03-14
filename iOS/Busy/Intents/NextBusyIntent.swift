import Foundation
import AppIntents
import WidgetKit

struct NextBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "NextBusy" }

    static var openAppWhenRun: Bool { true }

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
