//
//  ExpenseTrackerWidgetBundle.swift
//  ExpenseTrackerWidget
//
//  Created by Свят on 13.10.26.
//

import WidgetKit
import SwiftUI

@main
struct ExpenseTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        ExpenseTrackerWidget()
        ExpenseTrackerWidgetControl()
        ExpenseTrackerWidgetLiveActivity()
    }
}
