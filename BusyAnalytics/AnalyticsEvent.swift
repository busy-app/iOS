import Foundation

protocol AnalyticsEvent {
    var key: AnalyticsKey { get }
    var timestamp: TimeInterval { get }
    func parameters() -> [String: String]
}

extension AnalyticsEvent {
    var timestamp: TimeInterval  {
        Date().timeIntervalSince1970
    }
}

protocol TimerAnalyticsEvent: AnalyticsEvent {
    var timerParameters: TimerParameters { get }
}

protocol IntervalTimerAnalyticsEvent: TimerAnalyticsEvent {
    var interval: TimeInterval { get }
}
