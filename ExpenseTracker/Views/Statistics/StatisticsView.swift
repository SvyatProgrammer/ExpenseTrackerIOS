import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    
    @Query
    private var expenses : [Expense]
    
    @AppStorage("currency") private var currency : String = Currencies.usd.rawValue
    
    @State private var selectedPeriod : TimePeriod = .thisMonth
    @State private var customStartDate : Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var customEndDate : Date = Date()
    
    private var filtredExpenses : [Expense] {
        
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .thisMonth:
            return expenses.filter { expense in
                calendar.isDate(expense.date, equalTo: now, toGranularity: .month) && calendar.isDate(expense.date, equalTo: now, toGranularity: .year)
            }
        case .lastMonth:
            guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
                return []
            }
            return expenses.filter { expense in
                calendar.isDate(expense.date, equalTo: lastMonth, toGranularity: .month) && calendar.isDate(expense.date, equalTo: lastMonth, toGranularity: .year)
            }
        case .allTime:
            return expenses
        case .custom(let start, let end):
            let startOfDay = calendar.startOfDay(for: start)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end
            
            return expenses.filter { expense in
                expense.date >= startOfDay && expense.date <= endOfDay
            }
        }
    }
    
    private var totalSpent : Double {
        filtredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    private var averageSpent : Double {
        guard !filtredExpenses.isEmpty else { return 0.0 }
        return totalSpent / Double(filtredExpenses.count)
    }
    
    private var biggestSpent : Double {
        return filtredExpenses.map(\.amount).max() ?? 0.0
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: Period
                PeriodPicker(selectedPeriod: $selectedPeriod, customStartDate: $customStartDate, customEndDate: $customEndDate)
                
                // MARK: MainStats
                MainStats(totalSpent: totalSpent, averageSpent: averageSpent, biggestSpent: biggestSpent)
                
                // MARK: SectorMark by categories
                SectorMarkStats(filtredExpenses: filtredExpenses, totalSpent: totalSpent)
                
                // MARK: BarMark by categories
                BarMarkStats(filtredExpenses: filtredExpenses, totalSpent: totalSpent)
                
                // MARK: Categories
                CategoriesStats(filtredExpenses: filtredExpenses, totalSpent: totalSpent)
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Expense.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let context = container.mainContext

    context.insert(Expense(
        amount: 25.50,
        title: "Groceries",
        category: "Food",
        date: Date()
    ))

    context.insert(Expense(
        amount: 8.90,
        title: "Coffee",
        category: "Food",
        date: Date()
    ))

    context.insert(Expense(
        amount: 45.00,
        title: "Taxi",
        category: "Transport",
        date: Date()
    ))

    context.insert(Expense(
        amount: 15.99,
        title: "Netflix",
        category: "Entertainment",
        date: Date()
    ))

    context.insert(Expense(
        amount: 30.00,
        title: "New T-Shirt",
        category: "Shopping",
        date: Date()
    ))
    
    context.insert(Expense(
        amount: 30.00,
        title: "New T-Shirt",
        category: "Shopping",
        date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    ))

    return StatisticsView()
        .modelContainer(container)
}
