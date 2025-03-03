import SwiftUI

extension TimerView {
    struct FinishedView: View {
        var restart: () -> Void

        @Environment(\.appState) var appState

        @AppStorage("completed", store: .group) var completed: Int = 0
        @AppStorage("blocked", store: .group) var blocked: Int = 0

        var body: some View {
            VStack {
                VStack(spacing: 12) {
                    Image(.checkmarkGreen)
                        .resizable()
                        .frame(width: 108, height: 108)

                    Text("Superb!")
                        .font(.pragmaticaNextVF(size: 40))
                        .foregroundStyle(.whiteInvert)

                    Text("You’ve done this BUSY")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.whiteInvert)
                }
                .padding(.top, 54)

                StatsView(completed: completed, blocked: blocked)
                    .padding(.top, 10)

                Spacer()

                FinishButton {
                    appState.wrappedValue = .cards
                }

                RestartButton {
                    restart()
                }
                .padding(.top, 24)
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    stops: [
                        Gradient
                            .Stop(
                                color: .backgroundFinishedStart,
                                location: 0.00
                            ),
                        Gradient
                            .Stop(
                                color: .backgroundFinishedStop,
                                location: 1.00
                            ),
                    ],
                    startPoint: UnitPoint(x: 1.12, y: -0.28),
                    endPoint: UnitPoint(x: -0.06, y: 1.05)
                )
            )
            .task {
                completed += 1
            }
        }

        struct StatsView: View {
            let completed: Int
            let blocked: Int

            struct Card<Content: View>: View {
                @ViewBuilder var content: () -> Content

                var body: some View {
                    Group {
                        HStack {
                            content()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .background(.transparentWhiteInvertQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            }
            var body: some View {
                HStack(spacing: 2) {
                    Card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Total BUSYs completed")
                                .font(.pragmaticaNextVF(size: 18))
                                .foregroundStyle(.transparentWhiteInvertPrimary)

                            Text("\(completed)X")
                                .font(.pragmaticaNextVF(size: 40))
                                .foregroundStyle(.whiteInvert)
                        }
                    }

                    Card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Blocked app attempts")
                                .font(.pragmaticaNextVF(size: 18))
                                .foregroundStyle(.transparentWhiteInvertPrimary)

                            Text("\(blocked)X")
                                .font(.pragmaticaNextVF(size: 40))
                                .foregroundStyle(.e5)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TimerView.FinishedView {}
}
