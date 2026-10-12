import SwiftUI

enum TimePeriod : Hashable {
    case thisMonth
    case lastMonth
    case allTime
    case custom(startDate: Date, endDate: Date)
    
    var title: String {
        switch self {
        case .thisMonth: return "This Month"
        case .lastMonth: return "Last Month"
        case .allTime: return "All Time"
        case .custom: return "Custom"
        }
    }
}
