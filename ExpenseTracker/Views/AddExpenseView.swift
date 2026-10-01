import SwiftUI
import SwiftData

struct AddExpenseView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var amount = ""
    @State private var description = ""
    @State private var category = "Food"
    @State private var date = Date()
    
    let categories = [
        "Food",
        "Transport",
        "Shopping",
        "Entertainment",
        "Bills",
        "Other"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expense") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $description)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button("Add Expense") {
                        saveExpense()
                    }
                }
            }
            .navigationTitle("Add Expense")
        }
    }
    
    private func saveExpense() {
        guard let amount = Double(amount) else {
            return
        }
        
        let expense = Expense(amount: amount, title: description, category: category, date: date)
        
        modelContext.insert(expense)
    }
}

#Preview {
    AddExpenseView()
}
