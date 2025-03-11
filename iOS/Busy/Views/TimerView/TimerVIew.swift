import SwiftUI

struct TimerView: View {
    let interval: BusyState.Interval

    @Binding var busy: BusyState
    @Binding var settings: BusySettings

    @State var showConfirmationDialog: Bool = false

    @Environment(\.appState) var appState

    var name: String {
        switch interval.kind {
        case .work: settings.name
        case .rest: "Rest"
        case .longRest: "Long rest"
        }
    }

    var description: String {
        switch interval.kind {
        case .work: "\(busy.intervalNumber)/\(busy.intervalTotal)"
        case .rest, .longRest: ""
        }
    }

    var showPause: Bool {
        busy.state == .paused
    }

    var colors: [Color] {
        switch interval.kind {
        case .work: [.backgroundBusyStart, .backgroundBusyStop]
        case .rest: [.backgroundRestStart, .backgroundRestStop]
        case .longRest: [.backgroundLongRestStart, .backgroundLongRestStop]
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
                        busy.stop()
                        appState.wrappedValue = .cards
                    }
                    .colorScheme(.light)
                    .presentationBackground(.clear)
                    .presentationDetents([.height(230)])
                }

                Spacer()

                SkipButton {
                    busy.skip()
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

            TimeCard(
                duration: busy.timer.timeLeft,
                progress: busy.timer.timeLeft / interval.duration,
                kind: interval.kind
            )
            .padding(24)

            Spacer()

            PauseButton {
                busy.pause()
            }
            .padding(.top, 16)
            .padding(.bottom, 64)
        }
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            PauseOverlayView {
                busy.resume()
            }
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
            .background(DarkBlur())
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(16)
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
                            .font(.pragmaticaNextVF(size: 20))
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
                            .font(.pragmaticaNextVF(size: 20))
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
    @Previewable @State var settings = BusySettings()
    @Previewable @State var busy = BusyState.preview

    TimerView(
        interval: .init(kind: .work, duration: .minutes(15)),
        busy: $busy,
        settings: $settings
    )
    .colorScheme(.light)
    .task {
        busy.start()
    }
}

extension BusyState {
    var intervalNumber: Int {
        guard let interval else { return 0 }

        return intervals.intervals[...intervals.index].indices.filter {
            intervals.intervals[$0].kind == interval.kind
        }.count
    }

    var intervalTotal: Int {
        guard let interval else { return 0 }

        return intervals.intervals.indices.filter {
            intervals.intervals[$0].kind == interval.kind
        }.count
    }
}
