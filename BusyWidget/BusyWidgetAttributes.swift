import ActivityKit
import WidgetKit
import SwiftUI

struct BusyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var isOn: Bool
        var deadline: Date

        init(isOn: Bool, deadline: Date) {
            self.isOn = isOn
            self.deadline = deadline
        }
    }
    // Fixed non-changing properties about your activity go here!
}
