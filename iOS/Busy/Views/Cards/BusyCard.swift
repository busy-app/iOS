import SwiftUI

extension BusyApp {
    struct BusyCard: View {
        @Binding var settings: BusySettings
        @State private var isSettingsPresented: Bool = false

        var body: some View {
            Group {
                VStack {
                    HStack {
                        Text(settings.name)
                            .font(.pragmaticaNextVF(size: 24))
                            .foregroundStyle(.whiteInvert)

                        Spacer()

                        Button {
                            isSettingsPresented = true
                        } label: {
                            Text("Edit")
                                .font(.pragmaticaNextVF(size: 18))
                                .foregroundStyle(.transparentWhiteInvertPrimary)
                        }
                        .sheet(isPresented: $isSettingsPresented) {
                            SettingsView(settings: $settings)
                                .colorScheme(.light)
                                .presentationDragIndicator(.visible)
                        }
                    }

                    Spacer()

                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(settings.duration)
                                .font(.pragmaticaNextVF(size: 40))
                                .foregroundStyle(.whiteInvert)
                                .padding(.bottom, 16)

                            if settings.intervals.isOn {
                                IntervalsCard(settings: settings.intervals)
                                    .onLongPressGesture {
                                        settings.setDebugIntervals()
                                    }
                            }
                        }

                        Spacer()

                        if settings.blocker.selectedCount != 0 {
                            BlockedAppsCard(settings: settings.blocker)
                        }
                    }
                }
                .padding(24)
            }
            .frame(height: 232)
            .frame(maxWidth: .infinity)
            .background(.e5)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(16)
        }

        struct IntervalsCard: View {
            let settings: IntervalsSettings

            var body: some View {
                SmallCard {
                    HStack(spacing: 0) {
                        HStack(spacing: 4) {
                            Image(.busyIcon)
                                .renderingMode(.template)
                                .foregroundStyle(
                                    .transparentWhiteInvertPrimary
                                )
                            Text(settings.busy)
                        }

                        Color(uiColor: .white20)
                            .frame(width: 1)
                            .padding(8)

                        HStack(spacing: 4) {
                            Image(.restIcon)
                                .renderingMode(.template)
                                .foregroundStyle(
                                    .transparentWhiteInvertPrimary
                                )
                            Text(settings.rest)
                        }
                    }
                }
            }
        }

        struct BlockedAppsCard: View {
            let settings: BlockerSettings

            var body: some View {
                SmallCard {
                    HStack(spacing: 4) {
                        Image(.blockedIcon)
                            .renderingMode(.template)
                            .foregroundStyle(
                                .transparentWhiteInvertPrimary
                            )
                        Text(
                            settings.selectedCountString
                        )
                    }
                    .frame(minHeight: 0)
                }
            }
        }

        struct SmallCard<Content: View>: View {
            @ViewBuilder var content: () -> Content

            var body: some View {
                HStack(spacing: 0) {
                    content()
                }
                .frame(height: 32)
                .padding(.horizontal, 12)
                .background(.white20)
                .foregroundStyle(.transparentWhiteInvertPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    @Previewable @State var settings: BusySettings = .init()

    BusyApp.BusyCard(settings: $settings)
        .colorScheme(.light)
}
