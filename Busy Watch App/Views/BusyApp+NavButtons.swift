import SwiftUI

extension BusyView {
    typealias StopNavButton = BusyApp.StopNavButton
    typealias SkipNavButton = BusyApp.SkipNavButton
    typealias RestartNavButton = BusyApp.RestartNavButton
}

extension BusyApp {
    struct StopNavButton: View {
        var action: () -> Void

        var body: some View {
            NavButton(
                image: .navStopIcon,
                action: action
            )
        }
    }

    struct SkipNavButton: View {
        var action: () -> Void

        var body: some View {
            NavButton(
                image: .navSkipIcon,
                action: action
            )
        }
    }

    struct RestartNavButton: View {
        var action: () -> Void

        var body: some View {
            NavButton(
                image: .navRepeatIcon,
                action: action
            )
        }
    }

    struct NavButton: View {
        let image: ImageResource
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                Image(image)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 9)
                    .background(.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        BusyApp.StopNavButton {}

        BusyApp.SkipNavButton {}

        BusyApp.RestartNavButton {}
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .colorScheme(.light)
    .background(.black)
}
