import ActivityKit
import WidgetKit
import SwiftUI

struct BusyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusyWidgetAttributes.self) { context in
            VStack(spacing: 28) {
                HStack {
                    LargeTag(state: context.state)
                    Spacer()
                }

                LargeTimerWithAction(state: context.state)
            }
            .padding(16)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    LargeTag(state: context.state)
                        .padding(4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Spacer()
                        LargeTimerWithAction(state: context.state)
                    }
                    .padding(4)
                }
            } compactLeading: {
                MediumTag(state: context.state)
            } compactTrailing: {
                SmallTimerWithAction(state: context.state)
            } minimal: {
                SmallTag(state: context.state)
                    .frame(width: 45)
            }
        }
    }
}

extension BusyWidgetAttributes {
    fileprivate static var preview: BusyWidgetAttributes {
        BusyWidgetAttributes()
    }
}

extension BusyWidgetAttributes.ContentState {
    fileprivate static var workingActive: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            isOn: true,
            deadline: .now.addingTimeInterval(7200),
            tag: .working(current: 1, all: 3),
            event: .active
        )
    }

    fileprivate static var workingPaused: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            isOn: true,
            deadline: .now.addingTimeInterval(7200),
            tag: .working(current: 1, all: 3),
            event: .paused
        )
    }

    fileprivate static var workingCompleted: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            isOn: true,
            deadline: .now.addingTimeInterval(7200),
            tag: .working(current: 1, all: 3),
            event: .completed
        )
    }

    fileprivate static var restingActive: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            isOn: true,
            deadline: .now.addingTimeInterval(1230),
            tag: .resting,
            event: .active
        )
    }

    fileprivate static var restingPaused: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            isOn: true,
            deadline: .now.addingTimeInterval(1230),
            tag: .resting,
            event: .paused
        )
    }

    fileprivate static var restingCompleted: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            isOn: true,
            deadline: .now.addingTimeInterval(1230),
            tag: .resting,
            event: .completed
        )
    }
}

#Preview("Notification", as: .content, using: BusyWidgetAttributes.preview) {
   BusyWidgetLiveActivity()
} contentStates: {
    BusyWidgetAttributes.ContentState.workingActive
    BusyWidgetAttributes.ContentState.workingPaused
    BusyWidgetAttributes.ContentState.workingCompleted
    BusyWidgetAttributes.ContentState.restingActive
    BusyWidgetAttributes.ContentState.restingPaused
    BusyWidgetAttributes.ContentState.restingCompleted
}

#Preview(
    "Expanded",
    as: .dynamicIsland(.expanded),
    using: BusyWidgetAttributes.preview
) {
   BusyWidgetLiveActivity()
} contentStates: {
    BusyWidgetAttributes.ContentState.workingActive
    BusyWidgetAttributes.ContentState.workingPaused
    BusyWidgetAttributes.ContentState.workingCompleted
    BusyWidgetAttributes.ContentState.restingActive
    BusyWidgetAttributes.ContentState.restingPaused
    BusyWidgetAttributes.ContentState.restingCompleted
}

#Preview(
    "Compact",
    as: .dynamicIsland(.compact),
    using: BusyWidgetAttributes.preview
) {
   BusyWidgetLiveActivity()
} contentStates: {
    BusyWidgetAttributes.ContentState.workingActive
    BusyWidgetAttributes.ContentState.workingPaused
    BusyWidgetAttributes.ContentState.workingCompleted
    BusyWidgetAttributes.ContentState.restingActive
    BusyWidgetAttributes.ContentState.restingPaused
    BusyWidgetAttributes.ContentState.restingCompleted
}

#Preview(
    "Minimal",
    as: .dynamicIsland(.minimal),
    using: BusyWidgetAttributes.preview
) {
   BusyWidgetLiveActivity()
} contentStates: {
    BusyWidgetAttributes.ContentState.workingActive
    BusyWidgetAttributes.ContentState.workingPaused
    BusyWidgetAttributes.ContentState.workingCompleted
    BusyWidgetAttributes.ContentState.restingActive
    BusyWidgetAttributes.ContentState.restingPaused
    BusyWidgetAttributes.ContentState.restingCompleted
}
