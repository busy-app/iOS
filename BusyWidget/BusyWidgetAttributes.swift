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
        var time: ClosedRange<Date>
        var kind: IntervalKind

        init(
            state: TimerState,
            time: ClosedRange<Date>,
            kind: IntervalKind
        ) {
            self.state = state
            self.time = time
            self.kind = kind
        }
    }
    // Fixed non-changing properties about your activity go here!
}
