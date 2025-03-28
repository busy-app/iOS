import WatchConnectivity

final class Connectivity: NSObject, @unchecked Sendable {
    static let shared = Connectivity()

    @Published var settings: BusySettings?
    @Published var appState: AppState?
    @Published var busyState: BState?

    private override init() {
        super.init()
        #if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
        #endif
        WCSession.default.delegate = self
        WCSession.default.activate()
        print("Connectivity.init")
    }
}

extension Connectivity: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error {
            print("activationDidCompleteWith", error)
        }
        print("activationDidCompleteWith", activationState)
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    #endif

    public func send(
        settings: BusySettings,
        appState: AppState,
        busyState: BState?
    ) {
        #if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            print("compation app is not installed")
            return
        }
        #else
        guard WCSession.default.isWatchAppInstalled else {
            print("watch app is not installed")
            return
        }
        #endif

        do {
            var context: [String : Any] = [
                "settings": try JSONEncoder().encode(settings),
                "app_state": try JSONEncoder().encode(appState)
            ]
            if let busyState {
                context["busy_state"] = try JSONEncoder().encode(busyState)
            }
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("failed to update application context:", error)
        }
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        print("didReceiveApplicationContext", applicationContext.keys)
        handle(applicationContext)
    }

    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any] = [:]
    ) {
        print("didReceiveUserInfo", userInfo)
        handle(userInfo)
    }

    func handle(_ context: [String : Any]) {
        if let data = context["settings"] as? Data {
            handle(settings: data)
        }

        if let data = context["app_state"] as? Data {
            handle(appState: data)
        }

        if let data = context["busy_state"] as? Data {
            handle(busyState: data)
        }
    }

    func handle(settings data: Data) {
        do {
            let settings = try JSONDecoder()
                .decode(BusySettings.self, from: data)
            Task { @MainActor in
                self.settings = settings
            }
        } catch {
            print("error decoding settings:", error)
        }
    }

    func handle(appState data: Data) {
        do {
            let appState = try JSONDecoder()
                .decode(AppState.self, from: data)
            Task { @MainActor in
                self.appState = appState
            }
        } catch {
            print("error decoding app state:", error)
        }
    }

    func handle(busyState data: Data) {
        do {
            let busyState = try JSONDecoder()
                .decode(BState.self, from: data)
            Task { @MainActor in
                self.busyState = busyState
            }
        } catch {
            print("error decoding busy state:", error)
        }
    }
}

extension WCSessionActivationState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .activated: "activated"
        case .inactive: "inactive"
        case .notActivated: "notActivated"
        default: "unknown"
        }
    }
}
