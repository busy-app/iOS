import SwiftUI
import CoreBluetooth

struct ConnectView: View {
    @AppStorage("isPaired") var isPaired: Bool = false

    @State var handle: Any?

    var body: some View {
        VStack {
            Image("ConnectLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blackInvert)
                .padding(44)

            VStack {
                Spacer()
                VStack(spacing: 24) {
                    Spinner()
                    Text("Searching for DEVICE...")
                }
                Spacer()
            }

            Button {
                isPaired = true
            } label: {
                HStack(spacing: 2) {
                    Text("DEMO MODE")
                    Image("Chevron")
                        .renderingMode(.template)
                        .foregroundStyle(.brandPrimary)
                }
            }
            .padding(.bottom, 30)
        }
        .task {
            handle = CBCentralManager()
        }
    }
}
