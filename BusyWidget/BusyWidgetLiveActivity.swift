//
//  BusyWidgetLiveActivity.swift
//  BusyWidget
//
//  Created by Developer on 28.11.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BusyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BusyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BusyWidgetAttributes {
    fileprivate static var preview: BusyWidgetAttributes {
        BusyWidgetAttributes(name: "World")
    }
}

extension BusyWidgetAttributes.ContentState {
    fileprivate static var smiley: BusyWidgetAttributes.ContentState {
        BusyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BusyWidgetAttributes.ContentState {
         BusyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BusyWidgetAttributes.preview) {
   BusyWidgetLiveActivity()
} contentStates: {
    BusyWidgetAttributes.ContentState.smiley
    BusyWidgetAttributes.ContentState.starEyes
}
