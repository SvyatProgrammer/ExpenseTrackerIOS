import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Expense.date, order: .reverse)
    private var expenses : [Expense]
    
    @State private var selectedExpense : Expense?
    
    @AppStorage("currency") private var currency : String = Currencies.usd.rawValue
    @AppStorage("appTheme") private var appTheme = "system"
    
    private var filteredExpenses : [Expense] {
        let calendar = Calendar.current
        return expenses.filter { expense in
            calendar.isDate(expense.date, equalTo: Date(), toGranularity: .month)
        }
    }
    
    private var totalSpent : Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Total amount spent in a month")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(formatCurrency(totalSpent, currency: currency))
                        .font(.system(size: 40, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .primary.opacity(0.6), radius: 4)
                
                VStack(alignment: .leading) {
                    Text("Recent expenses")
                        .font(.title2)
                        .fontWeight(.semibold)
                    if filteredExpenses.isEmpty {
                        ContentUnavailableView("No expenses yet", systemImage: "wallet.bifold", description: Text("Add your first expense to get started."))
                    } else {
                        List {
                            ForEach(filteredExpenses) { expense in
                                ExpenseRow(expense: expense, currency: currency)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        selectedExpense = expense
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        modelContext.delete(expense)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                
                NavigationLink {
                    AddExpenseView(modelContext: modelContext)
                } label: {
                    Image(systemName: "plus")
                        .padding()
                        .font(.headline)
                }
                .buttonStyle(.glassProminent)
            }
            .navigationTitle("Expense Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .sheet(item: $selectedExpense) { expense in
            EditExpenseView(modelContext: modelContext, expense: expense)
        }
        .preferredColorScheme(
            appTheme == "light" ? .light :
            appTheme == "dark" ? .dark : nil
        )
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

    return ContentView()
        .modelContainer(container)
}
