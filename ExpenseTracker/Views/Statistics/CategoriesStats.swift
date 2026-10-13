import SwiftUI

struct CategoriesStats: View {
    
    @AppStorage("currency") private var currency : String = Currencies.usd.rawValue
    
    let filtredExpenses : [Expense]
    let totalSpent : Double
    
    
    var body: some View {
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
}
