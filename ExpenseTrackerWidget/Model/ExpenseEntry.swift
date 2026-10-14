import WidgetKit

struct ExpenseEntry : TimelineEntry {
    let date: Date
    let totalSpent : Double
    let recentExpenses : [WidgetExpenseItem]
}
