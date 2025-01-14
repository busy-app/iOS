import SwiftUI

struct TimePickerView: View {
    @Binding var isSignInPresented: Bool
    @Binding var isSettingsPresented: Bool
    @Binding var timerSettings: TimerSettings

    var action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    isSignInPresented = true
                } label: {
                    Image(systemName: "person")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.blackInvert)
                        .fontWeight(.thin)
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 40)
                Spacer()
                Button {
                    isSettingsPresented = true
                } label: {
                    Image(uiImage: .settings)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.blackInvert)
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(.backgroundDefault)
            .clipShape(
                .rect(cornerRadius: 16)
            )
            .padding(.bottom, 2)

            TimePicker(
                minute: $timerSettings.minute,
                second: $timerSettings.second
            )
            .background(.backgroundDefault)
            .clipShape(
                .rect(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 16
                )
            )

            BusyButton {
                action()
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 128)
            .background(.backgroundDefault)
        }
    }
}
