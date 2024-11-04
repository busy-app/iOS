import SwiftUI

struct LoginFlow: View {
    enum Destination {}

    var body: some View {
        NavigationStack {
            LoginToCloudView()
        }
    }
}
