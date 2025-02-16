import SwiftUI

extension TimerView {
    struct Time: View {
        let minutes: Int
        let seconds: Int

        var body: some View {
            HStack(spacing: 0) {
                Spacer(minLength: 0)

                HStack {
                    Spacer()
                    Text(String(format: "%02d", minutes))
                }

                Text(":")

                HStack {
                    Text(String(format: "%02d", seconds))
                    Spacer()
                }

                Spacer(minLength: 0)
            }
            .font(.jetBrainsMonoRegular(size: 64))
            .foregroundStyle(.surfacePrimary)
            .animation(.linear, value: minutes)
            .animation(.linear, value: seconds)
            .contentTransition(.numericText())
        }
    }
}
