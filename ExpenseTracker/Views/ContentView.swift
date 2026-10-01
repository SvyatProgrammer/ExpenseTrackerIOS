import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Expense.date, order: .reverse)
    private var expenses : [Expense]
    
    @State private var selectedExpense : Expense?
    
    @AppStorage("currency") private var currency = "USD"
    
    private var totalSpent : Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Total spent")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(formatCurrency(totalSpent, currency: currency))
                        .font(.system(size: 40, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
                
                VStack(alignment: .leading) {
                    Text("Recent expenses")
                        .font(.title2)
                        .fontWeight(.semibold)
                    if expenses.isEmpty {
                        ContentUnavailableView("No expenses yet", systemImage: "creditcard", description: Text("Add your first expense to get started."))
                    } else {
                        List {
                            ForEach(expenses) { expense in
                                // Вынести в отдельный класс
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(expense.title)
                                            .font(.headline)
                                        Text(expense.category)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(formatCurrency(expense.amount, currency: currency))
                                        .fontWeight(.semibold)
                                }
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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expense.self, inMemory: true)
}
