import SwiftUI

import FamilyControls
import ManagedSettings

extension BusyApp {
    struct SettingsView: View {
        @Binding var settings: BusySettings

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            ScrollView {
                VStack {
                    NameView(name: $settings.name)
                        .padding(.top, 32)
                        .padding(.horizontal, 16)

                    VStack(spacing: 0) {
                        Text("Total time")
                            .font(.ppNeueMontrealMedium(size: 16))
                            .foregroundStyle(.whiteInvert)

                        DurationPicker($settings.time, role: .total)
                    }
                    .padding(.top, 20)
                    .background(.blackInvert)

                    IntervalsToggle(isOn: $settings.intervals.isOn)
                        .padding(.top, 24)
                        .padding(.horizontal, 16)

                    IntervalsSettingsButtons(intervals: $settings.intervals)
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .disabled(!settings.intervals.isOn)
                        .opacity(settings.intervals.isOn ? 1 : 0.3)

                    HStack(spacing: 8) {
                        SoundSettingsButton(soundSettings: $settings.sound)
                        AppsSettingsButton(blockerSettings: $settings.blocker)
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)

                    SaveButton {
                        dismiss()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundDark)
        }
    }
}

struct AutoHeightModifier: ViewModifier {
    @State private var height: Double = 0.0

    struct Key: PreferenceKey {
        static let defaultValue: Double = .zero

        static func reduce(value: inout Double, nextValue: () -> Double) {
            value = nextValue()
        }
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: Key.self,
                        value: proxy.size.height
                    )
                }
            }
            .onPreferenceChange(Key.self) {
                height = $0
            }
            .presentationDetents([.height(height)])
    }
}

extension View {
    func presentationAutoHeight() -> some View {
        self.modifier(AutoHeightModifier())
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

    struct IntervalsToggle: View {
        @Binding var isOn: Bool
        
        var body: some View {
            CustomToggle(
                title: "Intervals",
                description: "Split total time into work and rest intervals",
                isOn: $isOn
            )
        }
    }

    struct IntervalsSettingsButtons: View {
        @Binding var intervals: IntervalsSettings

        @State private var showBusyIntervalEditor: Bool = false
        @State private var showRestIntervalEditor: Bool = false
        @State private var showLongRestIntervalEditor: Bool = false

        var body: some View {
            HStack(spacing: 8) {
                IntervalButton(
                    name: "Work",
                    icon: .busyIcon,
                    interval: $intervals.busy
                ) {
                    showBusyIntervalEditor = true
                }
                .sheet(isPresented: $showBusyIntervalEditor) {
                    IntervalSheet(
                        icon: .busyIcon,
                        name: "Work",
                        description:
                            "Pick how long you want to " +
                            "work during each interval",
                        interval: $intervals.busy,
                        role: .work
                    )
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
                }

                IntervalButton(
                    name: "Rest",
                    icon: .restIcon,
                    interval: $intervals.rest
                ) {
                    showRestIntervalEditor = true
                }
                .sheet(isPresented: $showRestIntervalEditor) {
                    IntervalSheet(
                        icon: .restIcon,
                        name: "Rest",
                        description:
                            "Pick how long you want to " +
                            "rest during each interval",
                        interval: $intervals.rest,
                        role: .rest
                    )
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
                }

                IntervalButton(
                    name: "Long rest",
                    icon: .longRestIcon,
                    interval: $intervals.longRest
                ) {
                    showLongRestIntervalEditor = true
                }
                .sheet(isPresented: $showLongRestIntervalEditor) {
                    IntervalSheet(
                        icon: .busyIcon,
                        name: "Long rest",
                        description:
                            "Pick how long you want to " +
                            "rest during each interval",
                        interval: $intervals.longRest,
                        role: .longRest
                    )
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
                }
            }
        }
    }

    struct IntervalButton: View {
        let name: String
        let icon: ImageResource
        @Binding var interval: Interval
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 22) {
                    Text(name)
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.transparentWhiteInvertPrimary)

                    HStack(spacing: 0) {
                        Image(icon)
                        Text(interval.duration)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.transparentWhiteInvertSecondary)
                        Image(.arrowIcon)
                    }
                }
                .padding(12)
            }
            .background(.transparentWhiteInvertQuinary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    struct IntervalSheet: View {
        let icon: ImageResource
        let name: String
        let description: String
        @Binding var interval: Interval
        let role: DurationPicker.Role

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Image(.busyIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.transparentWhiteInvertPrimary)

                    Text(name)
                        .foregroundStyle(.whiteInvert)
                        .font(.pragmaticaNextVF(size: 24))
                }
                .padding(.top, 36)
                .padding(.horizontal, 16)

                Text(description)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                    .foregroundStyle(.neutralTertiary)
                    .fixedSize(horizontal: false, vertical: true)

                DurationPicker($interval.duration, role: role)
                    .padding(.top, 16)

                CustomToggle(
                    title: "Autostart \(name.lowercased())",
                    description:
                        "\(name) interval will start automatically, " +
                        "without manual confirmation",
                    isOn: $interval.autostart
                )
                .padding(.top, 16)
                .padding(.horizontal, 16)

                SaveButton {
                    dismiss()
                }
                .padding(.vertical, 16)
            }
        }
    }

    struct SoundSettingsButton: View {
        @Binding var soundSettings: SoundSettings

        @State private var showSettings: Bool = false

        var text: String {
            soundSettings.alertBeforeWork || soundSettings.alertBeforeRest
                ? "On"
                : "Off"
        }

        var body: some View {
            Button {
                showSettings = true
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Sound")
                            .font(.pragmaticaNextVF(size: 18))
                            .foregroundStyle(.whiteInvert)

                        Spacer()

                        Image(.arrowIcon)
                    }

                    HStack(spacing: 4) {
                        Image(.soundIcon)
                        Text(text)
                            .font(.pragmaticaNextVF(size: 18))
                            .foregroundStyle(.transparentWhiteInvertPrimary)
                    }
                }
                .padding(12)
                .background(.transparentWhiteInvertQuinary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .sheet(isPresented: $showSettings) {
                SoundSettingsSheet(settings: $soundSettings)
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
            }
        }
    }

    struct SoundSettingsSheet: View {
        @Binding var settings: SoundSettings

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Image(.soundIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.transparentWhiteInvertPrimary)

                    Text("Sound")
                        .foregroundStyle(.whiteInvert)
                        .font(.pragmaticaNextVF(size: 24))

                    Spacer()
                }
                .padding(.top, 32)

                CustomToggle(
                    title: "Alert before work starts",
                    description:
                        "Get notified 5 seconds before your " +
                        "next work interval begins",
                    isOn: $settings.alertBeforeWork
                )
                .padding(.top, 32)

                CustomToggle(
                    title: "Alert before work ends",
                    description:
                        "Get notified 5 seconds before your " +
                        "current work interval ends",
                    isOn: $settings.alertBeforeRest
                )
                .padding(.top, 32)

                SaveButton {
                    dismiss()
                }
                .padding(.vertical, 16)
            }
            .padding(.horizontal, 16)
        }
    }

    struct AppsSettingsButton: View {
        @Binding var blockerSettings: BlockerSettings

        @State private var showSettings: Bool = false

        var body: some View {
            Button {
                showSettings = true
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Apps")
                            .font(.pragmaticaNextVF(size: 18))
                            .foregroundStyle(.whiteInvert)

                        Spacer()

                        Image(.arrowIcon)
                    }

                    HStack(spacing: 4) {
                        Image(.blockedIcon)
                        Text(blockerSettings.selectedCountString)
                            .font(.pragmaticaNextVF(size: 18))
                            .foregroundStyle(.transparentWhiteInvertPrimary)
                    }
                }
                .padding(12)
                .background(.transparentWhiteInvertQuinary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .sheet(isPresented: $showSettings) {
                AppsSettingsSheet(settings: $blockerSettings)
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
            }
        }
    }

    struct AppsSettingsSheet: View {
        @Binding var settings: BlockerSettings

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack(alignment: .leading) {
                Toggle(isOn: $settings.isOn) {
                    Text("Block apps")
                        .foregroundStyle(.whiteInvert)
                        .font(.pragmaticaNextVF(size: 24))
                }
                .tint(.accent)
                .padding(.top, 32)

                Text(
                    "Selected apps and their notifications will " +
                    "be blocked while BUSY is active"
                )
                .foregroundStyle(.neutralTertiary)
                .padding(.top, 12)

                SelectAppsButton(settings: $settings)
                    .padding(.top, 32)

                SaveButton {
                    dismiss()
                }
                .padding(.top, 32)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
        }
    }

    struct SelectAppsButton: View {
        @Binding var settings: BlockerSettings

        @State private var showPicker: Bool = false
        @State private var selection = FamilyActivitySelection()

        var body: some View {
            Button {
                showPicker = true
            } label: {
                HStack(spacing: 0) {
                    AppsIcons(settings: settings)
                    Spacer()
                    Text(settings.selectedCountString)
                        .font(.pragmaticaNextVF(size: 14))
                        .foregroundStyle(.transparentWhiteInvertSecondary)
                    Image(.arrowIcon)
                }
                .padding(16)
                .background(.transparentWhiteInvertQuinary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .familyActivityPicker(
                isPresented: $showPicker,
                selection: $selection
            )
            .onChange(of: selection) {
                settings.applicationTokens = selection.applicationTokens
                settings.categoryTokens = selection.categoryTokens
                settings.domainTokens = selection.webDomainTokens
            }
            .task {
                selection.applicationTokens = settings.applicationTokens
                selection.categoryTokens = settings.categoryTokens
                selection.webDomainTokens = settings.domainTokens
            }
        }
    }

    struct AppsIcons: View {
        let settings: BlockerSettings
        
        var body: some View {
            if settings.selectedCount == 0 {
                Image(.appsIcon)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(settings.categoryTokens), id: \.self) {
                            Label($0)
                                .labelStyle(.iconOnly)
                        }

                        ForEach(Array(settings.applicationTokens), id: \.self) {
                            Label($0)
                                .labelStyle(.iconOnly)
                        }
                    }
                }
            }
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
