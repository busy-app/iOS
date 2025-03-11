import ActivityKit
import WidgetKit
import SwiftUI

enum TimerState: Codable {
    case paused
    case running
    case finished
}

enum IntervalKind: Codable {
    case work
    case rest
    case longRest
}

struct BusyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {

        // Dynamic stateful properties about your activity go here!
        var state: TimerState
        var duration: Duration
        var kind: IntervalKind

        var deadline: Date {
            .now + Double(duration.components.seconds)
        }

        init(
            state: TimerState,
            duration: Duration,
            kind: IntervalKind
        ) {
            self.state = state
            self.duration = duration
            self.kind = kind
        }
    }
    // Fixed non-changing properties about your activity go here!
}
