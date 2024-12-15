import ActivityKit
import WidgetKit
import SwiftUI

struct BusyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusyWidgetAttributes.self) { context in
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Image("BusyIcon")

                    Text(timerInterval: .now...context.state.deadline)
                        .contentTransition(.numericText())
                        .foregroundStyle(.white)
                        .font(.system(size: 48))
                        .padding(.top, 12)
                }

                Spacer()

                Button(intent: StopBusyIntent()) {
                    Image("StopButton")
                }
                .padding(.top, 4)
                .buttonStyle(.plain)
            }
            .padding(16)
            .activityBackgroundTint(.widgetBackground)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Image("BusyIcon")
                            .padding(.top, 8)
                        Text(timerInterval: .now...context.state.deadline)
                            .contentTransition(.numericText())
                            .font(.system(size: 48))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Button(intent: StopBusyIntent()) {
                        Image("StopButton")
                    }
                    .padding(.top, 20)
                    .buttonStyle(.plain)
                }
            } compactLeading: {
                Image("BusyIcon")
                    .resizable()
                    .scaledToFit()
            } compactTrailing: {
                Text(timerInterval: .now...context.state.deadline)
                    .frame(minWidth: 0, maxWidth: 65)
                    .multilineTextAlignment(.trailing)
                    .contentTransition(.numericText())
            } minimal: {
                ProgressView(
                    timerInterval: .now...context.state.deadline,
                    label: { EmptyView() },
                    currentValueLabel: { EmptyView() }
                )
                .progressViewStyle(.circular)
                .tint(.tint)
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
    fileprivate static var on: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes
            .ContentState(isOn: true, deadline: .now.addingTimeInterval(30))
     }
     
     fileprivate static var off: BusyWidgetAttributes.ContentState {
         BusyWidgetAttributes
             .ContentState(isOn: false, deadline: .now.addingTimeInterval(30))
     }
}

#Preview("Notification", as: .content, using: BusyWidgetAttributes.preview) {
   BusyWidgetLiveActivity()
} contentStates: {
    BusyWidgetAttributes.ContentState.on
    BusyWidgetAttributes.ContentState.off
}
