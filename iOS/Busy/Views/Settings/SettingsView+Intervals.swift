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
                    guard !cantShit else { return }
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
                    guard !cantShit else { return }
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
                    guard !cantShit else { return }
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
                            .renderingMode(.template)
                            .foregroundStyle(
                                .transparentWhiteInvertPrimary
                            )
                        Text(interval.duration)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.transparentWhiteInvertSecondary)
                            .padding(.leading, 4)
                        Spacer(minLength: 0)
                        Image(.arrowIcon)
                            .opacity(0.3)
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
        let role: DurationPicker.Role

        @Binding var savedInterval: Interval
        @State var interval: Interval = .init(.zero)

        init(
            icon: ImageResource,
            name: String,
            description: String,
            interval: Binding<Interval>,
            role: DurationPicker.Role
        ) {
            self.icon = icon
            self.name = name
            self.description = description
            self._savedInterval = interval
            self.role = role
        }

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)

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
                    savedInterval = interval
                    dismiss()
                }
                .padding(.vertical, 16)
            }
            .onAppear {
                interval = savedInterval
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
    .preferredColorScheme(.dark)
    .sheet(isPresented: $isPresented) {
        BusyApp.SettingsView(settings: $settings)
            .colorScheme(.light)
            .presentationDragIndicator(.visible)
    }
}
