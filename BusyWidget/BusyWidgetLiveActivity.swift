import ActivityKit
import WidgetKit
import SwiftUI

struct BusyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusyWidgetAttributes.self) { context in
            VStack(spacing: 28) {
                HStack {
                    LargeTag(busy: context.state)
                    Spacer()
                }

                LargeTimerWithAction(busy: context.state)
            }
            .padding(16)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    LargeTag(busy: context.state)
                        .padding(4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Spacer()
                        LargeTimerWithAction(busy: context.state)
                    }
                    .padding(4)
                }
            } compactLeading: {
                MediumTag(state: context.state)
            } compactTrailing: {
                SmallTimerWithAction(busy: context.state)
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
            state: .running,
            duration: .seconds(3600),
            kind: .work
        )
    }

    fileprivate static var workingPaused: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            state: .paused,
            duration: .seconds(3600),
            kind: .work
        )
    }

    fileprivate static var workingCompleted: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            state: .finished,
            duration: .seconds(3600),
            kind: .work
        )
    }

    fileprivate static var restingActive: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            state: .running,
            duration: .seconds(1230),
            kind: .rest
        )
    }

    fileprivate static var restingPaused: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            state: .paused,
            duration: .seconds(1230),
            kind: .rest
        )
    }

    fileprivate static var restingCompleted: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(
            state: .finished,
            duration: .seconds(1230),
            kind: .rest
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
