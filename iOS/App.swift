import SwiftUI

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            BusyApp()
                .preferredColorScheme(.dark)
                .colorScheme(.light)
        }
    }
}

var isDemoBuild: Bool {
    #if DEBUG
    true
    #else
    guard let target = Bundle
        .main
        .object(forInfoDictionaryKey: "CI_TARGET") as? String
    else {
        return false
    }
    return target == "BUSY_APP"
    #endif
}
