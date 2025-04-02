import SwiftUI

extension BusyView {
    struct FinishedView: View {
        var restart: () -> Void
        var finish: () -> Void

        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    RestartNavButton {
                        restart()
                    }
                    Spacer()
                }

                Image(.checkmarkGreen)
                    .resizable()
                    .frame(width: 56, height: 56)

                Text("SUPERB!")
                    .font(.pragmaticaNextVF(size: 20))
                    .foregroundStyle(.white)

                Text("You’ve done this BUSY")
                    .font(.pragmaticaNextVF(size: 12))
                    .foregroundStyle(.white)
                    .padding(.top, 2)

                Spacer(minLength: 0)

                FinishButton {
                    finish()
                }
            }
            .padding(isAppleWatchLarge ? 20 : 12)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    BusyView.FinishedView {

    } finish: {

    }
}
