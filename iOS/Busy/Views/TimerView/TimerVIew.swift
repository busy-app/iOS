import SwiftUI

struct TimerView: View {
    @Binding var timer: Timer
    @Binding var settings: BusySettings

    @Environment(\.appState) var appState

    var name: String {
        switch appState.wrappedValue {
        case .working: settings.name
        case .resting: "Rest"
        case .longResting: "Long rest"
        default: ""
        }
    }

    var description: String {
        switch appState.wrappedValue {
        case .working: "1/3"
        default: ""
        }
    }

    var colors: [Color] {
        switch appState.wrappedValue {
        case .working: [.backgroundBusyStart, .backgroundBusyStop]
        case .resting: [.backgroundRestStart, .backgroundRestStop]
        case .longResting: [.backgroundLongRestStart, .backgroundLongRestStop]
        default: []
        }
    }

    var body: some View {
        VStack {
            Navigation(settings: $settings) {
                appState.wrappedValue = .cards
            }

            Title(
                name: name,
                description: description
            )
            .padding(.top, 36)

            Spacer()

            Time(
                minutes: timer.minutes,
                seconds: timer.seconds
            )

            SkipButton {
                switch appState.wrappedValue {
                case .working: appState.wrappedValue = .resting
                case .resting: appState.wrappedValue = .longResting
                case .longResting: appState.wrappedValue = .finished
                default: break
                }

            }
            .padding(.top, 18)

            Spacer()

            PauseButton {
                appState.wrappedValue = .paused(appState.wrappedValue)
            }
            .padding(.top, 16)
            .padding(.bottom, 64)
        }
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    @Previewable @State var timer = Timer.shared
    @Previewable @State var setting = BusySettings()

    TimerView(timer: $timer, settings: $setting)
        .colorScheme(.light)
}
