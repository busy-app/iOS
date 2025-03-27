import Foundation

struct TimerCompletedEvent: TimerAnalyticsEvent {
    let key = AnalyticsKey.timerCompleted

    let timerParameters: TimerParameters

    init(_ timerParameters: TimerParameters) {
        self.timerParameters = timerParameters
    }
    
    func parameters() -> [String: String] {
        timerParameters
            .collect()
            .modify("competition_time", "\(timestamp.ms)")
    }
}
