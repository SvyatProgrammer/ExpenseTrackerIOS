//
//  ExpenseTrackerWidgetLiveActivity.swift
//  ExpenseTrackerWidget
//
//  Created by Свят on 13.10.26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ExpenseTrackerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ExpenseTrackerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ExpenseTrackerWidgetAttributes.self) { context in
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

extension ExpenseTrackerWidgetAttributes {
    fileprivate static var preview: ExpenseTrackerWidgetAttributes {
        ExpenseTrackerWidgetAttributes(name: "World")
    }
}

extension ExpenseTrackerWidgetAttributes.ContentState {
    fileprivate static var smiley: ExpenseTrackerWidgetAttributes.ContentState {
        ExpenseTrackerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ExpenseTrackerWidgetAttributes.ContentState {
         ExpenseTrackerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ExpenseTrackerWidgetAttributes.preview) {
   ExpenseTrackerWidgetLiveActivity()
} contentStates: {
    ExpenseTrackerWidgetAttributes.ContentState.smiley
    ExpenseTrackerWidgetAttributes.ContentState.starEyes
}
