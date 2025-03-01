import SwiftUI

import FamilyControls
import ManagedSettings

extension BusyApp {
    struct SettingsView: View {
        @Binding var settings: BusySettings

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    NameView(name: $settings.name)
                        .padding(.top, 32)
                        .padding(.horizontal, 16)

                    VStack(spacing: 0) {
                        Text("Total time")
                            .font(.ppNeueMontrealMedium(size: 16))
                            .foregroundStyle(.whiteInvert)
                            .padding(.top, 24)

                        DurationPicker($settings.time, role: .total)
                            .padding(.top, 12)
                            .padding(.bottom, 32)
                    }
                    .background(.blackInvert)
                    .padding(.top, 8)

                    IntervalsToggle(isOn: $settings.intervals.isOn)
                        .padding(.top, 24)
                        .padding(.horizontal, 16)

                    IntervalsSettingsControl(intervals: $settings.intervals)
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                        .padding(.horizontal, 16)
                        .disabled(!settings.intervals.isOn)
                        .opacity(settings.intervals.isOn ? 1 : 0.3)

                    SoundSettingsControl(soundSettings: $settings.sound)
                        .padding(.top, 24)
                        .padding(.horizontal, 16)

                    AppsSettingsControl(blockerSettings: $settings.blocker)
                        .padding(.top, 24)
                        .padding(.horizontal, 16)

                    SaveButton {
                        dismiss()
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundDark)
        }
    }
}

extension BusyApp.SettingsView {
    struct NameView: View {
        @Binding var name: String

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .font(.pragmaticaNextVF(size: 14))
                    .foregroundStyle(.transparentWhiteInvertSecondary)

                TextField("", text: $name)
                    .font(.pragmaticaNextVF(size: 40))
                    .foregroundStyle(.whiteInvert)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(.transparentBlackInvertSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    struct SaveButton: View {
        var action: () -> Void

        var body: some View {
            VStack(alignment: .center) {
                Button {
                    action()
                } label: {
                    HStack {
                        Text("Save")
                            .font(.pragmaticaNextVF(size: 24))
                            .foregroundStyle(.whiteInvert)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 80)
                    .background(.transparentWhiteInvertTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 112))
                }
            }
            .frame(maxWidth: .infinity)
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
