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

        var description: String? {
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
            VStack(spacing: 0) {
                HStack {
                    StopNavButton {
                        showConfirmationDialog = true
                    }

                    Spacer()

                    SkipNavButton {
                        feedbackOnSkip()
                        busy.skip()
                        sendState()
                    }
                }

                Title(
                    name: name,
                    description: description
                )
                .padding(.top, 8)

                Spacer(minLength: 0)

                TimeCard(interval: interval)

                Spacer()

                PauseButton {
                    busy.pause()
                    sendState()
                }
            }
            .padding(isAppleWatchLarge ? 20 : 12)
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay {
                ConfirmationDialog {
                    busy.stop()
                    appState.wrappedValue = .cards
                    sendState()
                } onCancel: {
                    showConfirmationDialog = false
                }
                .edgesIgnoringSafeArea(.all)
                .opacity(showConfirmationDialog ? 1 : 0)
            }
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
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        func feedbackOnSkip() {
            WKInterfaceDevice.current().play(.click)
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
