import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    let category: ExpenseCategory
    let expenses: [Expense]
    let currency: String
    var isEditable: Bool = false

    @Environment(\.modelContext) private var modelContext
    @State private var selectedExpense: Expense?

    private var categoryExpenses: [Expense] {
        expenses
            .filter { $0.category == category.name }
            .sorted { $0.date > $1.date }
    }

    private var totalSpent: Double {
        categoryExpenses.reduce(0) { $0 + $1.amount }
    }

    private var biggestExpense: Expense? {
        categoryExpenses.max { $0.amount < $1.amount }
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .frame(width: 70, height: 70)
                        .background(
                            category.color,
                            in: Circle()
                        )

                    Text(category.name)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(
                        formatCurrency(
                            totalSpent,
                            currency: currency
                        )
                    )
                    .font(.largeTitle)
                    .fontWeight(.bold)

                    Text("Total spent")
                        .foregroundStyle(.secondary)

                    Text("\(categoryExpenses.count) transactions")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .listRowBackground(Color.clear)
            }

            Section("Biggest Expense") {
                if let expense = biggestExpense {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(expense.title.isEmpty ? category.name : expense.title)
                                .font(.headline)

                            Text(expense.date, format: .dateTime
                                .month(.abbreviated)
                                .day()
                                .year())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(
                            formatCurrency(
                                expense.amount,
                                currency: currency
                            )
                        )
                        .fontWeight(.semibold)
                    }
                } else {
                    Text("No expenses yet")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Expense History") {
                if categoryExpenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: category.icon,
                        description: Text(
                            "Expenses in this category will appear here."
                        )
                    )
                } else {
                    ForEach(categoryExpenses) { expense in
                        let row = HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(
                                    expense.title.isEmpty
                                    ? category.name
                                    : expense.title
                                )
                                .font(.headline)

                                Text(expense.date, format: .dateTime
                                    .month(.abbreviated)
                                    .day()
                                    .year())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(
                                formatCurrency(
                                    expense.amount,
                                    currency: currency
                                )
                            )
                            .fontWeight(.medium)
                        }
                        .padding(.vertical, 3)

                        if isEditable {
                            row.swipeActions(edge: .trailing) {
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
                        } else {
                            row
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedExpense) { expense in
            EditExpenseView(modelContext: modelContext, expense: expense)
        }
    }
}
