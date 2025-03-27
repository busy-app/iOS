import Foundation

struct TimerAbortedEvent: IntervalTimerAnalyticsEvent {
    let key = AnalyticsKey.timerAborted

    let timerParameters: TimerParameters
    let interval: TimeInterval

    init(_ interval: TimeInterval, _ timerParameters: TimerParameters) {
        self.interval = interval
        self.timerParameters = timerParameters
    }
    
    func parameters() -> [String: String] {
        timerParameters
            .collect()
            .modify("abort_time", "\(timestamp.ms)")
            .modify("progress_at_abort", "\(interval.ms)")
    }
}
