import SwiftUI

extension BusyView {
    struct WorkDoneView: View {
        @Binding var busy: BusyState

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

                Image(.checkmarkGreen)
                    .resizable()
                    .frame(width: 56, height: 56)

                Text("BUSY \(busy.intervalNumber)/\(busy.intervalTotal) done!")
                    .font(.pragmaticaNextVF(size: isAppleWatchLarge ? 20 : 16))
                    .foregroundStyle(.white)

                Text("It’s time to have a rest")
                    .font(.pragmaticaNextVF(size: 12))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.top, 2)

                Spacer(minLength: 0)

                WhiteButton {
                    next()
                } label: {
                    Text("Start REST")
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
    @Previewable @State var busy = BusyState.preview

    BusyView.WorkDoneView(busy: $busy) {}
        .colorScheme(.light)
}
