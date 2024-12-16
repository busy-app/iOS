import SwiftUI

import ManagedSettings

extension BusyApp {
    struct SettingsView: View {
        @Environment(\.dismiss) var dismiss
        @Binding var metronome: Bool

        var body: some View {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(.pragmaticaNextVF(size: 36))
                        Spacer()

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(5)
                        }
                    }
                    .padding(.vertical, 22)

                    AppBlocker()
                        .padding(.vertical, 24)

                    VStack {
                        Toggle("Metronome", isOn: $metronome)
                            .font(.pragmaticaNextVF(size: 16))
                            .padding(10)
                            .tint(.backgroundBusy)
                    }
                    .background(.transparentBlackInvertQuinary)
                    .cornerRadius(8)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .foregroundStyle(.blackInvert)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.backgroundDefault)
                .clipShape(
                    .rect(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 16
                    )
                )
                .padding(.top, 2)
            }
            .presentationBackground(Color.clear)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
