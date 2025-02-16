import SwiftUI

extension TimerView {
    struct Navigation: View {
        @Binding var settings: BusySettings
        let action: () -> Void

        @State private var isSettingsPresented: Bool = false

        var body: some View {
            HStack {
                Button {
                    action()
                } label: {
                    Image(.backArrowButton)
                }
                Spacer()

                Button {
                    isSettingsPresented = true
                } label: {
                    Image(.dots)
                }
            }
            .padding(.top, 13)
            .padding(.horizontal, 24)
            .sheet(isPresented: $isSettingsPresented) {
                BusyApp.SettingsView(settings: $settings)
                    .colorScheme(.light)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
