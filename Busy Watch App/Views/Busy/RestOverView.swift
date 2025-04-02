import SwiftUI

extension BusyView {
    struct RestOverView: View {
        var next: () -> Void

        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    StopNavButton {
                        appState.wrappedValue = .cards
                    }
                    Spacer()
                }

                Image(.compukter)
                    .resizable()
                    .frame(width: 56, height: 56)

                Text("Rest is over")
                    .font(.pragmaticaNextVF(size: 20))
                    .foregroundStyle(.white)

                Text("Time to get back to work")
                    .font(.pragmaticaNextVF(size: 12))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.top, 2)

                Spacer(minLength: 0)

                WhiteButton {
                    next()
                } label: {
                    Text("Start BUSY")
                        .font(.pragmaticaNextVF(size: 16))
                }
            }
            .padding(isAppleWatchLarge ? 20 : 12)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        }
    }
}

#Preview {
    BusyView.RestOverView {}
}
