import SwiftUI

struct BusyButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: .busyButton)
                .resizable()
                .scaledToFit()
        }
    }
}

struct StopButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: .stopButton)
                .resizable()
                .scaledToFit()
        }
    }
}
