import SwiftUI
import Foundation

struct ActiveTimer: View {
    @Binding var timer: Timer

    var itemsCount: Double { 5 }

    var body: some View {
        GeometryReader { proxy in
            let itemHeight = (proxy.size.height / itemsCount)

            VStack(spacing: 0) {
                Spacer()

                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Image("PlayIcon")
                            .renderingMode(.template)
                            .foregroundStyle(.blackInvert)
                            .padding(.bottom, 4)

                        Text("BUSY is active")
                            .font(.pragmaticaNextVF(size: 32))
                    }
                }
                .frame(height: 100)

                HStack(spacing: 0) {
                    Spacer(minLength: 0)

                    HStack {
                        Spacer()
                        Text(String(format: "%02d", timer.minutes))
                            .frame(height: itemHeight)
                    }

                    Text(":")
                        .frame(height: itemHeight)

                    HStack {
                        Text(String(format: "%02d", timer.seconds))
                            .frame(height: itemHeight)
                        Spacer()
                    }

                    Spacer(minLength: 0)
                }
                .animation(.linear, value: timer.minutes)
                .animation(.linear, value: timer.seconds)
                .contentTransition(.numericText())
                .padding(.vertical, 24)


                VStack {
                    Spacer()
                    HStack(spacing: 25) {
                        TimeButton("-5") {
                            timer.decrease()
                        }

                        PauseButton {
                            timer.pause()
                        }

                        TimeButton("+5") {
                            timer.increase()
                        }
                    }
                    Spacer()
                }
                .frame(height: 100)

                Spacer()
            }
        }
    }
}

private extension ActiveTimer {
    struct PauseButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                Image("PauseIcon")
                    .renderingMode(.template)
                    .foregroundStyle(.blackInvert)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .inset(by: 1)
                            .stroke(.blackInvert, lineWidth: 2)
                    )
            }
        }
    }

    struct TimeButton: View {
        let text: String
        var action: () -> Void

        init(_ text: String, action: @escaping () -> Void) {
            self.text = text
            self.action = action
        }

        var body: some View {
            Button {
                action()
            } label: {
                Text(text)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Circle()
                            .inset(by: 1)
                            .stroke(.blackInvert, lineWidth: 2)
                    )
            }
            .font(.pragmaticaNextVF(size: 24))
            .foregroundStyle(.blackInvert)
        }
    }
}
