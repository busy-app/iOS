import SwiftUI

struct TimerView: View {
    @Binding var timer: Timer
    @Binding var settings: BusySettings

    @Environment(\.appState) var appState

    @State var showConfirmationDialog: Bool = false

    var name: String {
        switch appState.wrappedValue {
        case .working, .paused(.working): settings.name
        case .resting, .paused(.resting): "Rest"
        case .longResting, .paused(.longResting): "Long rest"
        default: ""
        }
    }

    var description: String {
        switch appState.wrappedValue {
        case .working, .paused(.working): "1/3"
        default: ""
        }
    }

    var showPause: Bool {
        switch appState.wrappedValue {
        case .paused: true
        default: false
        }
    }

    var colors: [Color] {
        switch appState.wrappedValue {
        case .working, .paused(.working):
            [.backgroundBusyStart, .backgroundBusyStop]
        case .resting, .paused(.resting):
            [.backgroundRestStart, .backgroundRestStop]
        case .longResting, .paused(.longResting):
            [.backgroundLongRestStart, .backgroundLongRestStop]
        default:
            []
        }
    }

    var body: some View {
        VStack {
            HStack {
                StopButton {
                    showConfirmationDialog = true
                }
                .sheet(isPresented: $showConfirmationDialog) {
                    ConfirmationDialog {
                        appState.wrappedValue = .cards
                    }
                    .colorScheme(.light)
                    .presentationBackground(.clear)
                    .presentationDetents([.height(210)])
                }

                Spacer()

                SkipButton {
                    switch appState.wrappedValue {
                    case .working: appState.wrappedValue = .workDone
                    case .resting: appState.wrappedValue = .restOver
                    case .longResting: appState.wrappedValue = .finished
                    default: break
                    }
                }
            }
            .padding(.top, 12)
            .padding(.horizontal, 24)

            Title(
                name: name,
                description: description
            )
            .padding(.top, 36)

            Spacer()

            TimeCard(state: .init(
                minutes: timer.minutes,
                seconds: timer.seconds
            ))
            .padding(24)

            Spacer()

            PauseButton {
                appState.wrappedValue = .paused(appState.wrappedValue)
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            PauseOverlayView()
                .opacity(showPause ? 1 : 0)
        )
    }

    struct StopButton: View {
        let action: () -> Void

        public var body: some View {
            Button {
                action()
            } label: {
                HStack(spacing: 8) {
                    Image(.stopIconSmall)
                    Text("Stop")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.transparentWhiteInvertSecondary)
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 45)
            .background(.transparentWhiteInvertQuaternary)
            .clipShape(RoundedRectangle(cornerRadius: 111))
        }
    }

    struct SkipButton: View {
        let action: () -> Void

        public var body: some View {
            Button {
                action()
            } label: {
                HStack(spacing: 8) {
                    Image(.skipIconSmall)
                    Text("Skip")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.transparentWhiteInvertSecondary)
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 45)
            .background(.transparentWhiteInvertQuaternary)
            .clipShape(RoundedRectangle(cornerRadius: 111))
        }
    }

    struct ConfirmationDialog: View {
        var onConfirm: () -> Void
        @State var confirmed: Bool = false

        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            VStack {
                Text("Stopping will reset this BUSY progress. Are you sure?")
                    .font(.pragmaticaNextVF(size: 18))
                    .foregroundStyle(.whiteInvert)

                HStack(spacing: 12) {
                    StopButton {
                        confirmed = true
                        dismiss()
                    }

                    KeepButton {
                        dismiss()
                    }
                }
                .padding(.top, 48)
            }
            .padding(24)
            .background(.backgroundDark.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .onDisappear {
                if confirmed {
                    onConfirm()
                }
            }
        }

        struct StopButton: View {
            var action: () -> Void

            var body: some View {
                Button {
                    action()
                } label: {
                    HStack {
                        Image(.stopIcon)
                            .renderingMode(.template)
                        Text("Stop")
                            .font(.pragmaticaNextVF(size: 24))
                    }
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.blackInvert)
                    .background(.whiteInvert)
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
            }
        }

        struct KeepButton: View {
            var action: () -> Void

            var body: some View {
                Button {
                    action()
                } label: {
                    HStack {
                        Text("Keep BUSY")
                            .font(.pragmaticaNextVF(size: 24))
                    }
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.whiteInvert)
                    .background(.transparentWhiteInvertTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
            }
        }
    }
}

#Preview("Working") {
    @Previewable @State var timer = Timer.shared
    @Previewable @State var setting = BusySettings()

    TimerView(timer: $timer, settings: $setting)
        .colorScheme(.light)
        .environment(\.appState, .constant(.working))
}
