import SwiftUI

import ManagedSettings

extension BusyApp {
    struct SettingsView: View {
        @Environment(\.dismissModal) var dismissModal

        var body: some View {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(.pragmaticaNextVF(size: 36))
                        Spacer()

                        Button {
                            dismissModal()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(5)
                        }
                    }
                    .padding(.vertical, 22)
                    .padding(.horizontal, 16)

                    AppBlocker()

                    Spacer()
                }
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
