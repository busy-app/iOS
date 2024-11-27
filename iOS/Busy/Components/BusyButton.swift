import SwiftUI

struct BusyButton: View {
    let isOn: Bool
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: isOn ? .stopButton : .busyButton)
                .resizable()
                .scaledToFit()
        }
    }
}
