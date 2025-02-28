import ActivityKit
import WidgetKit
import SwiftUI

struct BusyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {

        // Dynamic stateful properties about your activity go here!
        var isOn: Bool
        var deadline: Date
        var tag: Tag
        var event: Event

        enum Tag: Codable, Hashable {
            case working(current: Int, all: Int)
            case resting
        }

        enum Event: Codable {
            case active
            case paused
            case completed
        }


        init(isOn: Bool, deadline: Date) {
            self.isOn = isOn
            self.deadline = deadline
            self.tag = .resting
            self.event = .active
        }

        init(
            isOn: Bool,
            deadline: Date,
            tag: Tag,
            event: Event
        ) {
            self.isOn = isOn
            self.deadline = deadline
            self.tag = tag
            self.event = event
        }
    }
    // Fixed non-changing properties about your activity go here!
}
