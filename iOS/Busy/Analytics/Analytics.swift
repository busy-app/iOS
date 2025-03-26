import Foundation
import BusyAnalytics

@MainActor
final class AppAnalytics: Sendable {
    static let shared = AppAnalytics()

    let analytics: Analytics

    private init() {
        self.analytics = Analytics()
    }

    func recordAppOpen() {
        analytics.appLaunched()
    }

    func recordTimerStarted(
        _ state: BusyState
    ) {
        analytics.timerStarted(parameters: .init(state: state))
    }

    func recordTimerCompleted(
        _ state: BusyState
    ) {
        analytics.timerCompleted(parameters: .init(state: state))
    }

    func recordTimerPaused(
        _ state: BusyState
    ) {
        analytics.timerPaused(
            interval: state.passed,
            parameters: .init(state: state)
        )
    }

    func recordTimerResumed(
        _ state: BusyState
    ) {
        analytics.timerResumed(
            interval: state.passed,
            parameters: .init(state: state)
        )
    }

    func recordTimerSkipped(
        _ state: BusyState
    ) {
        analytics.timerSkipped(
            interval: state.passed,
            parameters: .init(state: state)
        )
    }

    func recordTimerAborted(
        _ state: BusyState
    ) {
        analytics.timerAborted(
            interval: state.passed,
            parameters: .init(state: state)
        )
    }
}

fileprivate extension TimerParameters {
    @MainActor init(state: BusyState) {
        self.init(
            isIntervalsEnabled: state.settings.intervals.isOn,
            totalTime: state.settings.duration,
            workTimer: state.settings.intervals.busy.duration,
            restTime: state.settings.intervals.rest.duration,
            longRestTime: state.settings.intervals.rest.duration,
            isMetronomeEnabled: state.settings.sound.metronome,
            isMusicEnabled: state.settings.sound.intervals,
            isBlockingEnabled: state.settings.blocker.isOn,
            isAllAppBlocking: state.settings.blocker.isAllSelected
        )
    }
}

fileprivate extension BusyState {
    var passed: TimeInterval {
        return Date.now.timeIntervalSince(self.startTime ?? .now)
    }
}
