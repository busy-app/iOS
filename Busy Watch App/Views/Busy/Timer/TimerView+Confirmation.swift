import SwiftUI

extension BusyView.TimerView {
    struct ConfirmationDialog: View {
        var onConfirm: () -> Void
        var onCancel: () -> Void

        var body: some View {
            VStack(alignment: .leading) {
                Text("Stopping will reset BUSY progress. Are you sure?")
                    .font(.pragmaticaNextVF(size: 16))
                    .minimumScaleFactor(0.75)
                    .lineSpacing(16 * 0.3)
                    .foregroundStyle(.white)
                    .padding(.top, 24)

                Spacer()

                HStack(alignment: .bottom) {
                    Spacer()
                    VStack(spacing: 4) {
                        StopButton {
                            onConfirm()
                        }

                        KeepButton {
                            onCancel()
                        }
                    }
                    Spacer()
                }
                Spacer(minLength: 12)
            }
            .padding(.horizontal, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 32))
        }

        struct StopButton: View {
            var action: () -> Void

            var body: some View {
                Button(action: action) {
                    HStack {
                        Image(.stopIcon)
                            .renderingMode(.template)
                        Text("Stop")
                            .font(.pragmaticaNextVF(size: 16))
                    }
                    .frame(width: 125)
                    .padding(.vertical, 15)
                    .foregroundStyle(.black)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
                .buttonStyle(.borderless)
            }
        }

        struct KeepButton: View {
            var action: () -> Void

            var body: some View {
                Button(action: action) {
                    HStack {
                        Text("Keep BUSY")
                            .font(.pragmaticaNextVF(size: 16))
                    }
                    .frame(width: 125)
                    .padding(.vertical, 15)
                    .foregroundStyle(.black)
                    .background(.white.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
                .buttonStyle(.borderless)
            }
        }
    }
}
