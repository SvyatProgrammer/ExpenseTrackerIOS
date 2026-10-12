import Foundation
import SwiftUI

struct ExpenseRow : View {
    
    let expense : Expense
    let currency : String
    
    var body: some View {
        HStack {
            if let category = ExpenseCategory.all.first(where: { $0.name == expense.category }) {
                Image(systemName: category.icon)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(category.color)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)
                HStack(spacing: 10) {
                    Text(formattedDate(expense.date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(expense.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Text(formatCurrency(expense.amount, currency: currency))
                .fontWeight(.semibold)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }

        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(.dateTime.month(.abbreviated).day())
    }
}
