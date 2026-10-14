import SwiftUI
import Charts

struct BarMarkStats: View {
    
    @AppStorage("currency") private var currency : String = Currencies.usd.title
    
    let filtredExpenses : [Expense]
    let totalSpent : Double
    
    private var dailyExpenses : [DailyExpense] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: filtredExpenses) { expense in
            calendar.startOfDay(for: expense.date)
        }
        
        return grouped.map { (date, selfExpenses) in
            DailyExpense(date: date, amount: selfExpenses.reduce(0) { $0 + $1.amount }, expenses: selfExpenses)
        }
        .sorted(by: { $0.amount < $1.amount })
    }
    
    var body: some View {
        Section("By Days") {
            if filtredExpenses.isEmpty {
                ContentUnavailableView(
                        "No Expenses",
                        systemImage: "chart.bar",
                        description: Text(
                            "Add expenses to see your daily statistics."
                        )
                    )
                    .frame(height: 200)
            } else {
                Chart(dailyExpenses) { item in
                    BarMark(x: .value("Day", item.date, unit: .day), y: .value("Amount", item.amount))
                        .cornerRadius(4)
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text(formatCurrency(amount, currency: currency))
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(height: 200)
            }
        }
    }
}
