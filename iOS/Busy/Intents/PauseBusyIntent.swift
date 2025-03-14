import Foundation
import AppIntents
import WidgetKit

struct PauseBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "PauseBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    @MainActor func perform() async throws -> some IntentResult {
        guard let busy = BusyState.Holder.shared.current else {
            return .result()
        }

        busy.pause()
        return .result()
    }
}
