final class LogAnalyticsService: AnalyticsService {
    func track(event: any AnalyticsEvent) {
        #if DEBUG
        print("Track event by \(event.key.rawValue): \(event.parameters())")
        #endif
    }
}
