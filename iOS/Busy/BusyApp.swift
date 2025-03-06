import SwiftUI

import ManagedSettings
import FamilyControls

import ActivityKit

struct BusyApp: View {
    private var authorizationCenter: AuthorizationCenter { .shared }
    private var managedSettingsStore: ManagedSettingsStore { .init() }
    private var notifications: Notifications { .shared }

    var isAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    @AppStorage("busySettings")
    var busySettings: BusySettings = .init()

    @State private var timer = Timer.shared
    @State private var activity: Activity<BusyWidgetAttributes>?

    indirect enum AppState {
        case cards
        case paused(AppState)
        case working
        case workDone
        case resting
        case restOver
        case longResting
        case finished
    }

    @State var appState: AppState = .cards

    var body: some View {
        Group {
            switch appState {
            case .cards: CardsView(settings: $busySettings)
            case .paused: TimerView(timer: $timer, settings: $busySettings)
            case .working: TimerView(timer: $timer, settings: $busySettings)
            case .workDone: TimerView.WorkDoneView()
            case .resting: TimerView(timer: $timer, settings: $busySettings)
            case .restOver: TimerView.RestOverView()
            case .longResting: TimerView(timer: $timer, settings: $busySettings)
            case .finished: TimerView.FinishedView()
            }
        }
        .environment(\.appState, $appState)
        .task {
            #if !targetEnvironment(simulator)
            notifications.authorize()
            if !isAuthorized {
                authorize()
            }
            #endif
            disableShieldOnTerminate()
        }
    }

    func disableShieldOnTerminate() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            MainActor.assumeIsolated {
                stopBusy()
            }
        }
    }

    func authorize() {
        Task {
            do {
                try await AuthorizationCenter
                    .shared
                    .requestAuthorization(for: .individual)
            } catch {
                print("authorization error: \(error)")
            }
        }
    }

    func startBusy() {
        #if !targetEnvironment(simulator)
        if busySettings.blocker.isOn {
            guard isAuthorized else {
                authorize()
                return
            }
            enableShield()
        }
        #endif

        timer.onChange = {
            if timer.state == .running {
                updateActivity()
            } else {
                stopActivity()
            }
        }

        timer.onEnd = {
            notifications.notify()
        }

        timer.start(
            minutes: busySettings.intervals.busy.minutes,
            seconds: busySettings.intervals.busy.seconds
        )

        startActivity()
    }

    func stopBusy() {
        timer.stop()
        disableShield()
    }

    func enableShield() {
        managedSettingsStore.shield.applications =
            busySettings.blocker.applicationTokens
        managedSettingsStore.shield.applicationCategories =
            .specific(busySettings.blocker.categoryTokens, except: .init([]))

        managedSettingsStore.shield.webDomains =
            busySettings.blocker.domainTokens
        managedSettingsStore.shield.webDomainCategories =
            .specific(busySettings.blocker.categoryTokens, except: .init([]))
    }

    func disableShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil

        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}

extension BusyApp {
    var contentState: BusyWidgetAttributes.ContentState {
        .init(
            isOn: timer.state == .running,
            deadline: timer.deadline
        )
    }

    func startActivity() {
        activity = try? Activity<BusyWidgetAttributes>.request(
            attributes: .init(),
            content: .init(
                state: contentState,
                staleDate: contentState.deadline
            )
        )
    }

    func updateActivity() {
        let activity = self.activity
        Task {
            await activity?.update(
                .init(
                    state: contentState,
                    staleDate: contentState.deadline
                )
            )
        }
    }

    func stopActivity() {
        let activity = self.activity
        self.activity = nil
        Task {
            await activity?.end(.none, dismissalPolicy: .immediate)
        }
    }
}

#Preview {
    BusyApp()
        .colorScheme(.light)
}
