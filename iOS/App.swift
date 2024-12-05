import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            BusyApp()
                .modifier(BackgroundModifier())
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
