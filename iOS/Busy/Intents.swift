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

struct StartBusyIntent: LiveActivityIntent {
    static var title: LocalizedStringResource { "Start Busy" }

    static var openAppWhenRun: Bool { true }

    @Parameter(
        title: "Duration in Minutes",
        requestValueDialog: "How many minutes?"
    )
    var durationMinutes: Int

    @MainActor func perform() async throws -> some IntentResult {
        print("Starting Busy for \(durationMinutes) minutes")
        Timer.shared.start(minutes: durationMinutes, seconds: 0)
        return .result()
    }
}

struct BusyShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor { .red }

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartBusyIntent(),
            phrases: [ "Start \(.applicationName)" ],
            shortTitle: "Start Busy",
            systemImageName: "timer"
        )
        AppShortcut(
            intent: StopBusyIntent(),
            phrases: [ "Stop \(.applicationName)" ],
            shortTitle: "Stop Busy",
            systemImageName: "timer"
        )
    }
}
