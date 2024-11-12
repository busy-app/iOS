import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            if isDevBuild {
                Text("Dev build")
            } else {
                RootView()
            }
        }
    }
}

var isDevBuild: Bool {
    #if DEBUG
    true
    #else
    guard let target = Bundle
        .main
        .object(forInfoDictionaryKey: "CI_TARGET") as? String
    else {
        return false
    }
    return target == "DEV"
    #endif
}
