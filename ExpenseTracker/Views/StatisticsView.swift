import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    
    @Query
    private var expenses : [Expense]
    
    @AppStorage("currency") private var currency = "USD"
    
    @State private var selectedPeriod : TimePeriod = .thisMonth
    @State private var customStartDate : Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var customEndDate : Date = Date()
    
    private var totalSpent : Double {
        filtredExpenses.reduce(0) { $0 + $1.amount }
    }
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
    
    private var averageSpent : Double {
        guard !filtredExpenses.isEmpty else { return 0.0 }
        return totalSpent / Double(filtredExpenses.count)
    }
    
    private var biggestSpent : Double {
        return filtredExpenses.map(\.amount).max() ?? 0.0
    }
    
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
        NavigationStack {
            List {
                
                // NOTE: Period
                PeriodPicker(selectedPeriod: $selectedPeriod, customStartDate: $customStartDate, customEndDate: $customEndDate)
                
                // NOTE: MainStats
                MainStats(totalSpent: totalSpent, averageSpent: averageSpent, biggestSpent: biggestSpent)
                
                // NOTE: SectorMark by categories
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
                
                // NOTE: BarMark by categories
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
                
                // NOTE: Categories
                Section("Categories") {
                    ForEach(ExpenseCategory.all) { category in
                        let total = filtredExpenses
                            .filter { $0.category == category.name }
                            .reduce(0.0) { $0 + $1.amount }

                        let percentage = totalSpent > 0
                            ? total / totalSpent
                            : 0.0
                        NavigationLink {
                            CategoryDetailView(category: category, expenses:  filtredExpenses, currency: currency, isEditable: false)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: category.icon)
                                    .foregroundStyle(.white)
                                    .frame(width: 40, height: 40)
                                    .background(category.color, in: Circle())
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(category.name)
                                        .font(.headline)
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Capsule()
                                                .fill(Color.gray.opacity(0.15))
                                            
                                            Capsule()
                                                .fill(category.color)
                                                .frame(
                                                    width: geometry.size.width * percentage
                                                )
                                        }
                                    }
                                    .frame(height: 5)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(formatCurrency(total, currency: currency))
                                        .fontWeight(.semibold)
                                    
                                    Text("\(percentage * 100, specifier: "%.0f")%")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
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
