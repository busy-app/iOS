import SwiftUI

struct BackgroundModifier: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    @State var backgroundTask: UIBackgroundTaskIdentifier?

    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: endBackgroundTask()
                case .background: beginBackgroundTask()
                default: break
                }
            }
    }

    func beginBackgroundTask() {
        backgroundTask = UIApplication
            .shared
            .beginBackgroundTask(expirationHandler: endBackgroundTask)
    }

    func endBackgroundTask() {
        guard let backgroundTask else { return }
        UIApplication.shared.endBackgroundTask(backgroundTask)
        self.backgroundTask = nil
    }
}
