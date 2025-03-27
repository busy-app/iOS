import SwiftUI

extension BusyView.TimerView {
    struct Title: View {
        let name: String
        let description: String

        var body: some View {
            VStack(spacing: 0) {
                Text(name)
                    .font(.pragmaticaNextVF(size: 40))
                    .foregroundStyle(.whiteInvert)

                Text(description)
                    .font(.pragmaticaNextVF(size: 18))
                    .foregroundStyle(.transparentWhiteInvertSecondary)
                    .padding(.top, 18)
            }
        }
    }
}
