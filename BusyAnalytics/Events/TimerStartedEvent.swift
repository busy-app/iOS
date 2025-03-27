import Foundation

struct TimerStartedEvent: TimerAnalyticsEvent {
    let key = AnalyticsKey.timerStarted

    let timerParameters: TimerParameters

    init(_ timerParameters: TimerParameters) {
        self.timerParameters = timerParameters
    }

    func parameters() -> [String: String] {
        timerParameters
            .collect()
            .modify("start_time_utc", "\(timestamp.ms)")
    }
}
