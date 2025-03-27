protocol AnalyticsService: Sendable {
    func track(event: any AnalyticsEvent)
}
