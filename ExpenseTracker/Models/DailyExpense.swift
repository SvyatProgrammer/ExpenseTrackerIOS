import Foundation

struct DailyExpense: Identifiable {
    let id = UUID()
    let date : Date
    let amount : Double
    let expenses : [Expense]
}
