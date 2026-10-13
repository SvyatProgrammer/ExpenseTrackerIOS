import SwiftUI
import Charts

struct SectorMarkStats: View {
    
    let filtredExpenses : [Expense]
    let totalSpent : Double
    
    var body: some View {
        Section("By Categories") {
            if filtredExpenses.isEmpty {
                ContentUnavailableView(
                        "No Expenses",
                        systemImage: "chart.pie",
                        description: Text(
                            "Add expenses to see your statistics."
                        )
                    )
                    .frame(height: 200)
            } else {
                Chart {
                    ForEach(ExpenseCategory.all) { category in
                        let total = filtredExpenses
                            .filter { $0.category == category.name }
                            .reduce(0) { $0 + $1.amount}
                        
                        if total > 0 && totalSpent > 0 {
                            SectorMark(angle: .value("Amount", total), innerRadius: .ratio(0.6), angularInset: 2)
                                .foregroundStyle(by: .value("Category", category.name))
                                .annotation(position: .overlay) {
                                    if total != 0 {
                                        Text("\(String(format:  "%.1f", (total / totalSpent) * 100))%")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(4)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Capsule())
                                    }
                                }
                        }
                    }
                }
                .chartForegroundStyleScale(
                    mapping: { (categoryName: String) -> Color in
                        ExpenseCategory.all.first(where: { $0.name == categoryName })?.color ?? .gray
                    }
                )
                .chartLegend(position: .trailing)
                .frame(height: 200)
            }
        }
    }
}
