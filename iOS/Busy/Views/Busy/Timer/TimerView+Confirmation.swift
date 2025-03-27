import SwiftUI

extension BusyView.TimerView {
    struct ConfirmationDialog: View {
        var onConfirm: () -> Void
        @State var confirmed: Bool = false

        @Environment(\.dismiss) var dismiss

        var body: some View {
            VStack(alignment: .leading) {
                Text("Stopping will reset BUSY progress. Are you sure?")
                    .font(.pragmaticaNextVF(size: 18))
                    .lineSpacing(18 * 0.3)
                    .foregroundStyle(.whiteInvert)

                HStack(spacing: 12) {
                    StopButton {
                        confirmed = true
                        dismiss()
                    }

                    KeepButton {
                        dismiss()
                    }
                }
                .padding(.top, 48)
            }
            .padding(24)
            .background(Blur(.systemUltraThinMaterialDark))
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(16)
            .onDisappear {
                if confirmed {
                    onConfirm()
                }
            }
        }

        struct StopButton: View {
            var action: () -> Void

            var body: some View {
                Button {
                    action()
                } label: {
                    HStack {
                        Image(.stopIcon)
                            .renderingMode(.template)
                        Text("Stop")
                            .font(.pragmaticaNextVF(size: 20))
                    }
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.blackInvert)
                    .background(.whiteInvert)
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
            }
        }

        struct KeepButton: View {
            var action: () -> Void

            var body: some View {
                Button {
                    action()
                } label: {
                    HStack {
                        Text("Keep BUSY")
                            .font(.pragmaticaNextVF(size: 20))
                    }
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.whiteInvert)
                    .background(.transparentWhiteInvertTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
            }
        }
    }
}
