import SwiftUI

import ManagedSettings
import FamilyControls

struct BusyApp: View {
    var authorizationCenter: AuthorizationCenter { .shared }
    var managedSettingsStore: ManagedSettingsStore { .init() }
    var notifications: Notifications { .shared }

    var isAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    @AppStorage("timerSettings")
    var timerSettings: TimerSettings = .init()

    @AppStorage("blockerSettings")
    var blockerSettings: BlockerSettings = .init()

    @State var timer = Timer.shared

    @State var isSignInPresented: Bool = false
    @State var isSettingsPresented: Bool = false

    var isOn: Bool {
        get { timerSettings.isOn }
        nonmutating set { timerSettings.isOn = newValue }
    }

    var topBarBackground: Color {
        isOn ? .backgroundBusy : .backgroundDefault
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                topBarBackground
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.safeAreaInsets.top)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 16,
                            topTrailingRadius: 0
                        )
                    )
                    .padding(.bottom, 2)

                VStack(spacing: 0) {
                    ZStack {
                        if isOn {
                            TimerView(timer: $timer) {
                                stopBusy()
                            }
                        }

                        TimePickerView(
                            isSignInPresented: $isSignInPresented,
                            isSettingsPresented: $isSettingsPresented,
                            timerSettings: $timerSettings
                        ) {
                            guard timerSettings.isValid else {
                                return
                            }
                            #if !targetEnvironment(simulator)
                            guard isAuthorized else {
                                authorize()
                                return
                            }
                            #endif
                            startBusy()
                        }
                        .opacity(!isOn ? 1 : 0)
                    }
                    .font(.pragmaticaNextVF(size: 100))
                    .frame(maxHeight: .infinity)
                    .minimumScaleFactor(0.1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea(.all)
            .background(.blackOnContent)
            .onChange(of: timer.state) { old, new in
                if new == .stopped, isOn {
                    stopBusy()
                }
            }
            .fullScreenCover(
                isPresented: $isSignInPresented
            ) {
                LoginFlow()
                    .dismissModal($isSignInPresented)
            }
            .fullScreenCover(
                isPresented: $isSettingsPresented
            ) {
                SettingsView()
                    .dismissModal($isSettingsPresented)
                    .environment(\.blockerSettings, $blockerSettings)
            }
            .task {
                #if !targetEnvironment(simulator)
                notifications.authorize()
                if !isAuthorized {
                    authorize()
                }
                #endif
                if isOn {
                    startBusy()
                }

                NotificationCenter.default.addObserver(
                    forName: UIApplication.willTerminateNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    stopBusy()
                }
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
        timer.start(
            minutes: timerSettings.minute,
            seconds: timerSettings.second,
            onEnd: notifications.notify
        )
        if blockerSettings.isEnabled {
            enableShield()
        }
        isOn = true
    }

    func stopBusy() {
        isOn = false
        timer.stop()
        disableShield()
    }

    func enableShield() {
        managedSettingsStore.shield.applications =
            blockerSettings.applicationTokens
        managedSettingsStore.shield.applicationCategories =
            .specific(blockerSettings.categoryTokens, except: .init([]))

        managedSettingsStore.shield.webDomains =
            blockerSettings.domainTokens
        managedSettingsStore.shield.webDomainCategories =
            .specific(blockerSettings.categoryTokens, except: .init([]))
    }

    func disableShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil

        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}

#Preview {
    BusyApp()
}
