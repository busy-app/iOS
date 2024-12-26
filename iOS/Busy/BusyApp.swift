import SwiftUI

import Intents

import ManagedSettings
import FamilyControls

struct BusyApp: View {

    var authorizationCenter: AuthorizationCenter { .shared }
    var notifications: Notifications { .shared }

    var isFamilyControlsAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    var isAllowSiri: Bool {
        INPreferences.siriAuthorizationStatus() == .authorized
    }

    @AppStorage(UserDefaults.Keys.timerSettings.rawValue) // Note: edit to .timerSettings
    var timerSettings: TimerSettings = .init()

    @AppStorage(UserDefaults.Keys.metronome.rawValue) // Note: edit to .metronome
    var metronome: Bool = false

    @State var timer = Timer.shared
    @State var blocker = Blocker.shared

    @State var isSettingsPresented: Bool = false

    var isOn: Bool {
        timerSettings.isOn
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
                            isSettingsPresented: $isSettingsPresented,
                            timerSettings: $timerSettings
                        ) {
                            guard timerSettings.isValid else {
                                return
                            }
                            #if !targetEnvironment(simulator)
                            guard isFamilyControlsAuthorized else {
                                familyControlsAuthorize()
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
                isPresented: $isSettingsPresented
            ) {
                SettingsView(metronome: $metronome)
                    .environment(blocker)
            }
            .task {
                #if !targetEnvironment(simulator)
                notifications.authorize()
                if !isFamilyControlsAuthorized {
                    familyControlsAuthorize()
                }
                if !isAllowSiri {
                    siriAuthorization()
                }
                #endif

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

    func familyControlsAuthorize() {
        Task {
            do {
                try await authorizationCenter
                    .requestAuthorization(for: .individual)
            } catch {
                print("authorization error: \(error)")
            }
        }
    }

    func siriAuthorization() {
        INPreferences.requestSiriAuthorization {
            print("Siri authorization status: \($0)")
        }
    }

    func startBusy() {
        timer.start(
            minutes: timerSettings.minute,
            seconds: timerSettings.second,
            metronome: metronome,
            onEnd: notifications.notify
        )
        blocker.enableShield()
    }

    func stopBusy() {
        timer.stop()
        blocker.disableShield()
    }
}

#Preview {
    BusyApp()
}
