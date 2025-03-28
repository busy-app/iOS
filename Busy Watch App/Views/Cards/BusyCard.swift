import SwiftUI
import Synchronization

extension BusyApp {
    struct BusyCard: View {
        @Binding var settings: BusySettings

        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("BUSY")
                        .font(.pragmaticaNextVF(size: 20))
                        .foregroundStyle(.white)

                    Spacer()
                }

                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(settings.duration)
                            .font(.pragmaticaNextVF(size: 20))
                            .foregroundStyle(.white)

                        if settings.intervals.isOn {
                            IntervalsCard(settings: settings.intervals)
                        }
                    }

                    Spacer()

                    if settings.blocker.selectedCount != 0 {
                        BlockedAppsCard(settings: settings.blocker)
                    }
                }
                .padding(.top, 20)
            }
            .padding(12)
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    struct IntervalsCard: View {
        let settings: IntervalsSettings

        var body: some View {
            SmallCard {
                HStack(spacing: 0) {
                    HStack(spacing: 2.3) {
                        Image(.busyIcon)
                            .renderingMode(.template)
                        Text(settings.busy)
                    }

                    Color.white.opacity(0.2)
                        .frame(width: 0.6)
                        .padding(5.25)

                    HStack(spacing: 2.3) {
                        Image(.restIcon)
                            .renderingMode(.template)
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
            .frame(height: 20)
            .padding(.horizontal, 12)
            .background(.white.opacity(0.2))
            .font(.pragmaticaNextVF(size: 11))
            .foregroundStyle(.white.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5.6))
        }
    }
}

#Preview {
    @Previewable @State var settings: BusySettings = .init()

    BusyApp.BusyCard(settings: $settings)
        .colorScheme(.light)
}
