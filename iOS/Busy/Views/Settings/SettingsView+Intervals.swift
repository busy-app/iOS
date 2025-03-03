import SwiftUI

extension BusyApp.SettingsView {
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

    struct IntervalsSettingsControl: View {
        @Binding var intervals: IntervalsSettings

        @State private var showBusyIntervalEditor: Bool = false
        @State private var showRestIntervalEditor: Bool = false
        @State private var showLongRestIntervalEditor: Bool = false

        // Fix presentationDetents height issue
        @State private var cantShit: Bool = false

        var body: some View {
            HStack(spacing: 8) {
                IntervalButton(
                    name: "Work",
                    icon: .busyIcon,
                    interval: $intervals.busy
                ) {
                    cantShit = true
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
                    .onDisappear {
                        cantShit = false
                    }
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
                }

                IntervalButton(
                    name: "Rest",
                    icon: .restIcon,
                    interval: $intervals.rest
                ) {
                    cantShit = true
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
                    .onDisappear {
                        cantShit = false
                    }
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
                }

                IntervalButton(
                    name: "Long rest",
                    icon: .longRestIcon,
                    interval: $intervals.longRest
                ) {
                    cantShit = true
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
                    .onDisappear {
                        cantShit = false
                    }
                    .presentationDragIndicator(.visible)
                    .presentationAutoHeight()
                    .colorScheme(.light)
                }
            }
            .disabled(cantShit)
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
                        Spacer(minLength: 0)
                        Image(.arrowIcon)
                    }
                }
                .padding(.vertical, 12)
                .padding(.leading, 12)
                .padding(.trailing, 6)
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
                    .padding(.top, 26)
                    .padding(.bottom, 32)
                    .background(.blackInvert)
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
