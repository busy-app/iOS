import SwiftUI

extension BusyView {
    struct TimerView: View {
        let interval: BusyState.Interval

        @Binding var busy: BusyState
        @Binding var settings: BusySettings

        @State var showPause: Bool = false
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
                            sendState()
                        }
                        .colorScheme(.light)
                        .presentationBackground(.clear)
                        .presentationDetents([.height(240)])
                    }

                    Spacer()

                    SkipButton {
                        busy.skip()
                        sendState()
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

                TimeCard(interval: interval)
                    .padding(24)

                Spacer()

                PauseButton {
                    busy.pause()
                    sendState()
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
                    sendState()
                }
                .opacity(showPause ? 1 : 0)
                .onChange(of: busy.state) {
                    showPause = busy.state == .paused
                }
            )
        }

        func sendState() {
            Connectivity.shared.send(
                settings: settings,
                appState: appState.wrappedValue,
                busyState: .init(
                    timerState: busy.state,
                    interval: busy.intervals.index,
                    elapsed: busy.interval?.elapsed ?? .seconds(0)
                )
            )
        }
    }
}

extension BusyView.TimerView {
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
}

#Preview("Working") {
    @Previewable @State var settings = BusySettings()
    @Previewable @State var busy = BusyState.preview

    BusyView.TimerView(
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
