import SwiftUI

extension BusyApp {
    struct BusyCardButton: View {
        @Binding var settings: BusySettings

        @State private var isSettingsPresented: Bool = false

        var body: some View {
            Button {
                isSettingsPresented = true
            } label: {
                BusyCard(settings: $settings)
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView(settings: $settings)
                    .colorScheme(.light)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

private struct BusyCard: View {
    @Binding var settings: BusySettings

    var body: some View {
        Group {
            VStack {
                HStack {
                    Text(settings.name)
                        .font(.pragmaticaNextVF(size: 24))
                        .foregroundStyle(.whiteInvert)

                    Spacer()

                    Text("Edit")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.transparentWhiteInvertPrimary)
                }

                Spacer()

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(settings.intervals.total)
                            .font(.pragmaticaNextVF(size: 40))
                            .foregroundStyle(.whiteInvert)
                            .padding(.bottom, 16)

                        if true {
                            SmallCard {
                                HStack(spacing: 0) {
                                    HStack(spacing: 4) {
                                        Image(.busyIcon)
                                        Text(settings.intervals.busy)
                                    }

                                    Color(uiColor: .white20)
                                        .frame(width: 1)
                                        .padding(8)

                                    HStack(spacing: 4) {
                                        Image(.restIcon)
                                        Text(settings.intervals.rest)
                                    }
                                }
                            }
                        }
                    }

                    Spacer()

                    SmallCard {
                        HStack(spacing: 4) {
                            Image(.blockedIcon)
                            Text(
                                settings.blocker.selectedCountString
                            )
                        }
                        .frame(minHeight: 0)
                    }
                    .opacity(settings.blocker.selectedCount == 0 ? 0 : 1)
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

#Preview {
    @Previewable @State var settings: BusySettings = .init()

    BusyCard(settings: $settings)
        .colorScheme(.light)
}
