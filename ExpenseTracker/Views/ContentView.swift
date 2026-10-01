import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Total spent")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("$0.00")
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
                    ContentUnavailableView("No expenses yet", systemImage: "creditcard", description: Text("Add your first expense to get started."))
                }
                
                NavigationLink {
                    AddExpenseView()
                } label: {
                    Label("Add Expense", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.glassProminent)
                
                Spacer()
            }
            .navigationTitle("Expense Tracker")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
