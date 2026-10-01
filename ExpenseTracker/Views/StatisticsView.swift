import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    
    @Query
    private var expenses : [Expense]
    
    @AppStorage("currency") private var currency = "USD"
    
    var body: some View {
        NavigationStack {
            List {
                Chart {
                    ForEach(ExpenseCategory.all) { category in
                        let total = expenses
                            .filter { $0.category == category.name }
                            .reduce(0) { $0 + $1.amount}
                        
                        BarMark(x: .value("Category", category.name), y: .value("Amount", total))
                    }
                }
                .frame(height: 250)
                
                Section("By categories") {
                    ForEach(ExpenseCategory.all) { category in
                        let total = expenses
                            .filter { $0.category == category.name}
                            .reduce(0) { $0 + $1.amount }
                        
                        HStack {
                            Image(systemName: category.icon)
                                .frame(width: 30)
                            
                            Text(category.name)
                            
                            Spacer()
                            
                            Text(formatCurrency(total, currency: currency))
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: Expense.self, inMemory: true)
}
