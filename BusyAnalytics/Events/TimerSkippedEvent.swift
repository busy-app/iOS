import Foundation

struct TimerSkippedEvent: IntervalTimerAnalyticsEvent {
    let key = AnalyticsKey.timerSkipped

    let timerParameters: TimerParameters
    let interval: TimeInterval

    init(_ interval: TimeInterval, _ timerParameters: TimerParameters) {
        self.interval = interval
        self.timerParameters = timerParameters
    }

    func parameters() -> [String: String] {
        timerParameters
            .collect()
            .modify("skip_time", "\(timestamp.ms)")
            .modify("progress_at_skip", "\(interval.ms)")
    }
}
