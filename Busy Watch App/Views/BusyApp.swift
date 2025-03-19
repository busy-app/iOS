import SwiftUI

struct BusyApp: View {
    @State var settings: BusySettings = .init()

    var body: some View {
        BusyCard(settings: $settings)
    }
}
#Preview {
    BusyApp()
}
