import SwiftUI

extension TimerView {
    struct FinishedView: View {
        @Environment(\.appState) var appState

        var body: some View {
            VStack {
                VStack(spacing: 12) {
                    Text("Superb!")
                        .font(.pragmaticaNextVF(size: 40))
                        .foregroundStyle(.whiteInvert)

                    Text("You’ve done this BUSY")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.whiteInvert)
                }
                .padding(.top, 54)

                Image(.stats)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 35)
                    .padding(.horizontal, 24)

                Spacer()

                FinishButton {
                    appState.wrappedValue = .cards
                }

                RestartButton {
                    appState.wrappedValue = .working
                }
                .padding(.top, 24)
                .padding(.bottom, 12)
            }
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
        }
    }
}

#Preview {
    TimerView.FinishedView()
}
