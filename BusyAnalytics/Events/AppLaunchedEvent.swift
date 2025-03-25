import Foundation

struct AppLaunchedEvent: AnalyticsEvent {
    let key = AnalyticsKey.appLaunched

    func parameters() -> [String: String] {
        [
            "app_version": Bundle.version,
            "timestamp": "\(timestamp.ms)"
        ]
    }
}

fileprivate extension Bundle {
    static var version: String {
        "\(releaseVersion) (\(buildNumber))"
    }

    static var releaseVersion: String {
        main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    static var buildNumber: String {
        main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
