import Foundation
import BusyAnalytics

extension BusyState {
    func recordTimerStarted() {
        analytics.timerStarted(parameters: TimerParameters(state: self))
    }

    func recordTimerCompleted() {
        analytics.timerCompleted(parameters: TimerParameters(state: self))
    }

    func recordTimerPaused() {
        analytics.timerPaused(
            interval: passed,
            parameters: TimerParameters(state: self)
        )
    }

    func recordTimerResumed() {
        analytics.timerResumed(
            interval: passed,
            parameters: TimerParameters(state: self)
        )
    }

    func recordTimerSkipped() {
        analytics.timerSkipped(
            interval: passed,
            parameters: TimerParameters(state: self)
        )
    }

    func recordTimerAborted() {
        analytics.timerAborted(
            interval: passed,
            parameters: TimerParameters(state: self)
        )
    }

    var passed: TimeInterval {
        return Date.now.timeIntervalSince(self.startTime ?? .now)
    }
}

extension TimerParameters {
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
