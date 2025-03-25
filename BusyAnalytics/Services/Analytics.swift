import Foundation

final public class Analytics: Sendable {
    private let services: [AnalyticsService] = [
        FirebaseAnalyticsService(),
        LogAnalyticsService()
    ]

    public init() {}

    public func appLaunched() {
        let event = AppLaunchedEvent()
        services.forEach { $0.track(event: event) }
    }

    public func timerStarted(parameters: TimerParameters) {
        let event = TimerStartedEvent(parameters)
        services.forEach { $0.track(event: event) }
    }

    public func timerCompleted(parameters: TimerParameters) {
        let event = TimerCompletedEvent(parameters)
        services.forEach { $0.track(event: event) }
    }

    public func timerPaused(
        interval: TimeInterval,
        parameters: TimerParameters
    ) {
        let event = TimerPausedEvent(interval, parameters)
        services.forEach { $0.track(event: event) }
    }

    public func timerResumed(
        interval: TimeInterval,
        parameters: TimerParameters
    ) {
        let event = TimerResumedEvent(interval, parameters)
        services.forEach { $0.track(event: event) }
    }

    public func timerSkipped(
        interval: TimeInterval,
        parameters: TimerParameters
    ) {
        let event = TimerSkippedEvent(interval, parameters)
        services.forEach { $0.track(event: event) }
    }

    public func timerAborted(
        interval: TimeInterval,
        parameters: TimerParameters
    ) {
        let event = TimerAbortedEvent(interval, parameters)
        services.forEach { $0.track(event: event) }
    }

    public func blockedAppAttempt(
        attemptCount: Int
    ) {
        let event = BlockedAppAttemptEvent(attemptCount)
        services.forEach { $0.track(event: event) }
    }
}
