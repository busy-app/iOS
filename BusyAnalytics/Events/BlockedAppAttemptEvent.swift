import Foundation

struct BlockedAppAttemptEvent: AnalyticsEvent {
    let key = AnalyticsKey.blockedAppAttempt

    let attemptCount: Int
    
    init(_ attemptCount: Int) {
        self.attemptCount = attemptCount
    }
    
    func parameters() -> [String: String] {
        [
            "attempt_time": "\(timestamp.ms)",
            "attempt_count": "\(attemptCount)",
        ]
    }
}
