import Foundation

struct TimerPausedEvent: IntervalTimerAnalyticsEvent {
    let key = AnalyticsKey.timerPaused

    let timerParameters: TimerParameters
    let interval: TimeInterval

    init(_ interval: TimeInterval, _ timerParameters: TimerParameters) {
        self.interval = interval
        self.timerParameters = timerParameters
    }

    func parameters() -> [String: String] {
        timerParameters
            .collect()
            .modify("pause_time", "\(timestamp.ms)")
            .modify("current_progress", "\(interval.ms)")
    }
}
