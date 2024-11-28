import SwiftUI

import ManagedSettings
import FamilyControls

struct BusyApp: View {
    var authorizationCenter: AuthorizationCenter { .shared }
    var managedSettingsStore: ManagedSettingsStore { .init() }

    var isAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    @AppStorage("isOn") var isOn: Bool = false

    @AppStorage("minute") var minute: Int = 15
    @AppStorage("second") var second: Int = 0

    @State var timer = Timer()

    var background: Color {
        isOn ? .backgroundBusy : .backgroundDefault
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                background
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
                            ActiveTimer(timer: $timer)
                        }

                        TimePicker(
                            minute: $minute,
                            second: $second
                        )
                        .opacity(!isOn ? 1 : 0)
                    }
                    .font(.pragmaticaNextVF(size: 100))
                    .frame(maxHeight: .infinity)
                    .minimumScaleFactor(0.1)

                    Spacer(minLength: 0)

                    BusyButton(isOn: isOn) {
                        guard minute > 0 || second > 0 else {
                            return
                        }
                        // TODO: Uncomment when we have permissions 
//                        guard isAuthorized else {
//                            authorize()
//                            return
//                        }
                        !isOn ? startBusy() : stopBusy()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 128)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(background)
                .clipShape(
                    .rect(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 16
                    )
                )
            }
            .ignoresSafeArea(.all)
            .background(.blackOnContent)
            .onChange(of: timer.state) { old, new in
                if new == .stopped, isOn {
                    stopBusy()
                }
            }
            .task {
                if !isAuthorized {
                    authorize()
                }
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
        timer.start(minutes: minute, seconds: second)
        enableShield()
        isOn = true
    }

    func stopBusy() {
        isOn = false
        timer.stop()
        disableShield()
    }

    func enableShield() {
        managedSettingsStore.shield.applicationCategories = .all(except: [])
        managedSettingsStore.shield.webDomainCategories = .all(except: [])
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
