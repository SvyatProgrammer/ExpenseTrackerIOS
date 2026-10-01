import SwiftUI
import SwiftData

struct EditExpenseView: View {
    
    var modelContext : ModelContext
    var expense : Expense
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount = ""
    @State private var description = ""
    @State private var category = "Food"
    @State private var date = Date()
    @State private var showError = false
    
    init(modelContext: ModelContext, expense: Expense) {
        self.modelContext = modelContext
        self.expense = expense
        
        _amount = State(initialValue: String(expense.amount))
        _description = State(initialValue: expense.title)
        _category = State(initialValue: expense.category)
        _date = State(initialValue: expense.date)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expense") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $description)
                    
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.all) { expenseCategory in
                            Text(expenseCategory.name)
                                .tag(expenseCategory.name)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button("Edit Expense") {
                        saveExpense()
                        
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Expense")
            .alert("Invalid amount", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid amount.")
            }
        }
    }
    
    private func saveExpense() {
        guard let amount = Double(amount), amount > 0 else {
            showError = true
            return
        }
        
        expense.amount = amount
        expense.title = description
        expense.category = category
        expense.date = date
        
        dismiss()
    }
}
