import SwiftUI

extension BusyView {
    struct FinishedView: View {
        var restart: () -> Void

        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    RestartButton {
                        appState.wrappedValue = .cards
                    }

                    Spacer()
                }

                VStack(spacing: 0) {
                    Image(.checkmarkGreen)

                    Text("SUPERB!")
                        .font(.pragmaticaNextVF(size: 20))
                        .foregroundStyle(.white)
                        .padding(.top, 2)

                    Text("You’ve done this BUSY")
                        .font(.pragmaticaNextVF(size: 12))
                        .foregroundStyle(.white)
                        .padding(.top, 2)

                    FinishButton {
                        appState.wrappedValue = .cards
                    }
                    .padding(.top, 20)
                }
                .padding(.top, 4)
                .padding(.bottom, 12)
            }
            .padding(20)
            .edgesIgnoringSafeArea(.all)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black, location: 0.00),
                        Gradient.Stop(color: Color(red: 0.06, green: 0.08, blue: 0.28), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 1.12, y: -0.28),
                    endPoint: UnitPoint(x: -0.06, y: 1.05)
                )
            )
        }
    }
}

#Preview {
    BusyView.FinishedView {}
}
