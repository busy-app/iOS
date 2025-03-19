import Foundation

extension UserDefaults {
    static var group: UserDefaults {
        .init(suiteName: "group.app.busy")!
    }
}
