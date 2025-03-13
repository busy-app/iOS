import SwiftUI

extension BusyApp.SettingsView {
    struct SoundSettingsControl: View {
        @Binding var soundSettings: SoundSettings

        var body: some View {
            VStack(spacing: 22) {
                SoundSettingControl(
                    title: "Sound",
                    description:
                        "Get notified when current interval ends and " +
                        "it's time to start the next one",
                    isOn: $soundSettings.intervals
                )

                SoundSettingControl(
                    title: "Metronome",
                    description: "Play a ticking sound during work interval",
                    isOn: $soundSettings.metronome
                )
            }
            .padding(12)
            .background(.transparentWhiteInvertQuinary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    struct SoundSettingControl: View {
        let title: String
        let description: String
        let isOn: Binding<Bool>

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.whiteInvert)

                    Text(description)
                        .padding(.top, 8)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(18 * 0.3)
                        .font(.pragmaticaNextVF(size: 14))
                        .foregroundStyle(.transparentWhiteInvertSecondary)
                }

                Spacer()

                Toggle(isOn: isOn) {
                    EmptyView()
                }
                .labelsHidden()
                .tint(.accent)
            }
        }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var settings: BusySettings = .init()

    Button("Show") {
        isPresented = true
    }
    .sheet(isPresented: $isPresented) {
        BusyApp.SettingsView(settings: $settings)
            .colorScheme(.light)
            .presentationDragIndicator(.visible)
    }
}
