import SwiftUI

extension TimerView {
    struct WorkDoneView: View {
        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                Spacer()

                Image(.checkmarkGreen)
                    .resizable()
                    .frame(width: 132, height: 132)

                Text("BUSY 1/3 done!")
                    .font(.pragmaticaNextVF(size: 32))
                    .foregroundStyle(.whiteInvert)
                    .padding(.top, 12)

                Text("It’s time to have a rest")
                    .foregroundStyle(.transparentWhiteInvertPrimary)
                    .padding(.top, 12)

                Button {
                    // appState.wrappedValue = .resting
                } label: {
                    Text("Start rest")
                        .font(.pragmaticaNextVF(size: 24))
                        .foregroundStyle(.blackInvert)
                        .frame(width: 202, height: 64)
                        .background(.whiteInvert)
                        .clipShape(RoundedButton())
                        .padding(.top, 32)
                }

                Spacer()

                Button {
                    // appState.wrappedValue = .finished
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
    TimerView.WorkDoneView()
        .colorScheme(.light)
}
