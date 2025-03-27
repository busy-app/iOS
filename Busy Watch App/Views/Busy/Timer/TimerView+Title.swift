import SwiftUI

extension BusyView.TimerView {
    struct Title: View {
        let name: String
        let description: String?

        var body: some View {
            VStack(spacing: 2) {
                Spacer()
                Text(name)
                    .font(.pragmaticaNextVF(size: 20))
                    .foregroundStyle(.white)

                if let description {
                    Text(description)
                        .font(.pragmaticaNextVF(size: 14))
                        .foregroundStyle(.white.opacity(0.3))
                }
                Spacer()
            }
            .frame(height: 34)
        }
    }
}
