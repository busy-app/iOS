import SwiftUI

@main
struct App: SwiftUI.App {
    init() {
        BusyShortcuts.updateAppShortcutParameters()
    }

    var body: some Scene {
        WindowGroup {
            BusyApp()
                .preferredColorScheme(.dark)
                .colorScheme(.light)
                .task {
                    CachedVideoPlayer.touch()
                }
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
