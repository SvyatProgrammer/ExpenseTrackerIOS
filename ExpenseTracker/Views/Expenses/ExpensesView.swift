import SwiftUI
import SwiftData

struct ExpensesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse)
    private var expenses: [Expense]
    
    @AppStorage("currency") private var currency : String = Currencies.usd.rawValue
    @State private var selectedExpense: Expense?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ExpenseCategory.all) { category in
                    // Получаем все расходы для текущей категории
                    let categoryExpenses = expenses.filter { $0.category == category.name }
                    let totalAmount = categoryExpenses.reduce(0.0) { $0 + $1.amount }
                    
                    NavigationLink {
                        // Экран детального просмотра категории со списком расходов
                        CategoryDetailView(
                            category: category,
                            expenses: categoryExpenses,
                            currency: currency,
                            isEditable: true
                        )
                    } label: {
                        HStack(spacing: 12) {
                            // Иконка категории
                            Image(systemName: category.icon)
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(category.color, in: Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.name)
                                    .font(.headline)
                                
                                // Количество записей в категории
                                Text("\(categoryExpenses.count) \(categoryExpenses.count == 1 ? "record" : "records")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            // Общая сумма по категории
                            Text(formatCurrency(totalAmount, currency: currency))
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Expenses")
        }
        .sheet(item: $selectedExpense) { expense in
            EditExpenseView(modelContext: modelContext, expense: expense)
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Expense.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let context = container.mainContext

    context.insert(Expense(amount: 25.50, title: "Groceries", category: "Food", date: Date()))
    context.insert(Expense(amount: 8.90, title: "Coffee", category: "Food", date: Date()))
    context.insert(Expense(amount: 45.00, title: "Taxi", category: "Transport", date: Date()))
    context.insert(Expense(amount: 15.99, title: "Netflix", category: "Entertainment", date: Date()))

    return ExpensesView()
        .modelContainer(container)
}
