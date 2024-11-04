import SwiftUI

struct MainView: View {
    @AppStorage("selectedTab") private var selectedTab: Tab = .login

    enum Tab: String, RawRepresentable, Hashable {
        case login
        case device
        case apps
    }

    private let initialTab: Tab?

    init(initialTab: Tab? = nil) {
        self.initialTab = initialTab
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                LoginView()
                    .tabItem {
                        Image(.loginTab)
                            .renderingMode(.template)
                    }
                    .tag(Tab.login)

                DeviceView()
                    .tabItem {
                        Image(.deviceTab)
                            .renderingMode(.template)
                    }
                    .tag(Tab.device)

                AppsView() 
                    .tabItem {
                        Image(.appsTab)
                            .renderingMode(.template)
                    }
                    .tag(Tab.apps)
            }
            .padding(.top, 4)
            .toolbarBackground(.neutralSenary, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.primary)
        .task {
            if let initialTab {
                selectedTab = initialTab
            }
        }
    }
}

#Preview {
    MainView()
}
