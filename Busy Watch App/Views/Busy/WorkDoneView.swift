import SwiftUI

extension BusyView {
    struct WorkDoneView: View {
        var next: () -> Void

        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    StopButton {
                        appState.wrappedValue = .cards
                    }
                    Spacer()
                }

                VStack(spacing: 0) {
                    Image(.checkmarkGreen)

                    Text("BUSY 1/3 done")
                        .font(.pragmaticaNextVF(size: 20))
                        .foregroundStyle(.white)
                        .padding(.top, 2)

                    Text("It’s time to have a rest")
                        .font(.pragmaticaNextVF(size: 12))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.top, 2)

                    WhiteButton {
                        next()
                    } label: {
                        Text("Start REST")
                            .font(.pragmaticaNextVF(size: 16))
                    }
                    .padding(.top, 20)
                }
                .padding(.top, 4)
                .padding(.bottom, 12)
            }
            .padding(20)
            .edgesIgnoringSafeArea(.all)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        }
    }
}

#Preview {
    BusyView.WorkDoneView {}
}
