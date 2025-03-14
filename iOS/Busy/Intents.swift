import Foundation
import AppIntents
import WidgetKit

struct StopBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "StopBusy" }

    static var openAppWhenRun: Bool { true }

    init() {
    }

    @MainActor func perform() async throws -> some IntentResult {
        // await Timer.shared.stop()
        guard let busy = BusyState.Holder.shared.current else {
            return .result()
        }

        switch busy.state {
        case .paused:
            busy.start()
        case .running:
            busy.pause()
        case .finished:
            busy.next()
            busy.start()
        }
        return .result()
    }
}
