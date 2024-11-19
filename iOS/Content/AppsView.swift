import SwiftUI

struct AppsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Row(
                    id: .busy,
                    icon: "BusyStatusIcon",
                    name: "BUSY STATUS",
                    image: "BusyStatusImage"
                )

                Divider()
                    .background(.neutralQuinary)

                Row(
                    id: .pomodoro,
                    icon: "PomodoroTimerIcon",
                    name: "POMODORO TIMER",
                    image: "PomodoroTimerImage"
                )

                Divider()
                    .background(.neutralQuinary)

                Row(
                    id: .wallpapersGifs,
                    icon: "WallpapersGifsIcon",
                    name: "WALLPAPERS & GIFS",
                    image: "WallpapersGifsImage"
                )

                Divider()
                    .background(.neutralQuinary)

                Row(
                    id: .clockWeather,
                    icon: "ClockWeatherIcon",
                    name: "CLOCK & WEATHER",
                    image: "ClockWeatherImage"
                )

                Divider()
                    .background(.neutralQuinary)

                Row(
                    id: .instargram,
                    icon: "InstagramStatsIcon",
                    name: "INSIGHT STATS",
                    image: "InstagramStatsImage"
                )
            }
            .padding(.top, 14)
            .padding(.horizontal, 14)
            .padding(.bottom, 40)
        }
        .background(.whiteInvert)
    }

    struct Row: View {
        let id: SelectedApp
        let icon: String
        let name: String
        let image: String

        @State var customizeApp = false

        @Environment(\.dismiss) var dismiss

        @AppStorage("selectedApp") private var selectedApp: SelectedApp = .busy

        var body: some View {
            VStack(spacing: 20) {
                HStack {
                    Image(icon)
                        .renderingMode(.template)
                        .foregroundColor(.blackInvert)

                    Text(name)
                        .foregroundColor(.blackInvert)
                        .font(.ppNeueMontrealRegular(size: 18))

                    Spacer()

                    Button {
                        customizeApp = true
                    } label: {
                        HStack(spacing: 2) {
                            Text("CUSTOMIZE")
                                .font(.ppNeueMontrealRegular(size: 12))
                            Image("ChevronRegular")
                                .renderingMode(.template)
                        }
                        .foregroundColor(.neutralTertiary)
                    }
                    .alert(isPresented: $customizeApp) {
                        Alert(
                            title: Text(
                                "The App doesn't support customizations"
                            )
                        )
                    }
                    .opacity(0)
                }

                Image(image)
                    .resizable()
                    .scaledToFit()

                FilledButton("RUN APP") {
                    selectedApp = id
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    MainView(initialTab: .apps)
}
