
import SwiftUI

extension TimerView {
    struct RestOverView: View {
        var action: () -> Void

        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                Spacer()

                Image(.compukter)

                Text("Rest is over")
                    .font(.pragmaticaNextVF(size: 32))
                    .foregroundStyle(.whiteInvert)
                    .padding(.top, 12)

                Text("Time to get back to work")
                    .foregroundStyle(.transparentWhiteInvertPrimary)
                    .padding(.top, 12)

                Button {
                    action()
                } label: {
                    Text("Start BUSY")
                        .font(.pragmaticaNextVF(size: 24))
                        .foregroundStyle(.blackInvert)
                        .frame(width: 202, height: 64)
                        .background(.whiteInvert)
                        .clipShape(RoundedButton())
                        .padding(.top, 32)
                }

                Spacer()

                Button {
                    appState.wrappedValue = .cards
                } label: {
                    Text("Finish for today")
                        .foregroundStyle(.transparentWhiteInvertPrimary)
                        .font(.pragmaticaNextVF(size: 18))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
            }
            .padding(.top, 51)
            .padding(.bottom, 8)
            .background(.backgroundDark)
        }
    }
}

#Preview {
    TimerView.RestOverView {}
        .colorScheme(.light)
}
