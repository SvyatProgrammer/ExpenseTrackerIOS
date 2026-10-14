import SwiftUI
import SwiftData

struct AddExpenseView: View {
    
    var modelContext : ModelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("currency") private var currency : String = Currencies.usd.title
    
    @State private var amount = ""
    @State private var description = ""
    @State private var category = "Food"
    @State private var date = Date()
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(formatCurrency(0.00, currency: currency), text: $amount)
                    .keyboardType(.decimalPad)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 40))
                    .padding()
                
                Section("Category") {
                    CategoryPicker(category: $category)
                }
                
                Section("Description") {
                    TextField("Description", text: $description)
                }
                
                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveExpense()
                    } label : {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .alert("Invalid amount", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid amount.")
            }
            
            Button {
                saveExpense()
            } label: {
                Text("Add expense")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
            }
            .buttonStyle(.glassProminent)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    
    private func saveExpense() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        guard let number = formatter.number(from: amount) else {
            showError = true
            return
        }
        
        let amountDouble = number.doubleValue
        
        guard amountDouble > 0 else {
            showError = true
            return
        }
        
        let expense = Expense(amount: amountDouble, title: description, category: category, date: date)
        
        modelContext.insert(expense)
        
        dismiss()
    }
}

#Preview {
    AddExpenseView(modelContext: ModelContext(
        try! ModelContainer(
            for: Expense.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    ))
}
