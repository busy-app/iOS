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
                        busy.skip()
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                Title(
                    name: name,
                    description: description
                )
                .padding(.top, 12)

                TimeCard(interval: interval)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                Spacer()

                PauseButton {
                    busy.pause()
                }
                .padding(.top, 13)
            }
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
                } onCancel: {
                    showConfirmationDialog = false
                }
                .edgesIgnoringSafeArea(.all)
                .opacity(showConfirmationDialog ? 1 : 0)
            }
            .overlay(
                PauseOverlayView {
                    busy.resume()
                }
                .opacity(showPause ? 1 : 0)
                .onChange(of: busy.state) {
                    showPause = busy.state == .paused
                }
            )
            .edgesIgnoringSafeArea(.all)
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
