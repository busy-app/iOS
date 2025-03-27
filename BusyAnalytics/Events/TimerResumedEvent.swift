import Foundation

struct TimerResumedEvent: IntervalTimerAnalyticsEvent {
    let key = AnalyticsKey.timerResumed

    let timerParameters: TimerParameters
    let interval: TimeInterval

    init(_ interval: TimeInterval, _ timerParameters: TimerParameters) {
        self.interval = interval
        self.timerParameters = timerParameters
    }

    func parameters() -> [String: String] {
        timerParameters
            .collect()
            .modify("resume_time", "\(timestamp.ms)")
            .modify("current_progress", "\(interval.ms)")
    }
}
