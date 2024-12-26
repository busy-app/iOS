import Foundation
import AppIntents
import WidgetKit

struct StopBusyIntent: AppIntent {
    static var title: LocalizedStringResource { "Stop Busy" }

    static var openAppWhenRun: Bool { true }

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            Timer.shared.stop()
            Blocker.shared.disableShield()
        }
        return .result()
    }
}

struct StartBusyIntent: LiveActivityIntent {

    static var title: LocalizedStringResource { "Start Busy" }
    static var description: IntentDescription {
        IntentDescription("Start a busy for a specific amount of time")
    }
    static var parameterSummary: some ParameterSummary {
        Summary("Start Busy on \(\.$minutes) minutes and \(\.$seconds) seconds")
    }

    @Parameter(
        title: "minutes",
        description: "The number of minutes to start busy",
        controlStyle: .field,
        inclusiveRange: (
            lowerBound: 0,
            upperBound: 59
        ),
        requestValueDialog: "How many minutes?"
    )
    var minutes: Int

    @Parameter(
        title: "seconds",
        description: "The number of seconds to start busy",
        controlStyle: .field,
        inclusiveRange: (
            lowerBound: 0,
            upperBound: 59
        ),
        requestValueDialog: "How many seconds?"
    )
    var seconds: Int

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            Timer.shared.start(
                minutes: minutes,
                seconds: seconds,
                metronome: UserDefaultsStorage.shared.metronome,
                onEnd: {}
            )
            Blocker.shared.enableShield()
        }
        return .result()
    }
}

struct BusyShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor { .red }

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartBusyIntent(),
            phrases: [
                "Start \(.applicationName)"
            ],
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
