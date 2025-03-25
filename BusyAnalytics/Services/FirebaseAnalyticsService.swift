import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsService {
    func track(event: any AnalyticsEvent) {
        #if !DEBUG
        FirebaseAnalytics.Analytics.logEvent(
            event.key.rawValue,
            parameters: event.parameters()
        )
        #endif
    }
}
