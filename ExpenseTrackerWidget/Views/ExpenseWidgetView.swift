import SwiftUI
import WidgetKit

struct ExpenseWidgetView : View {
    var entry: ExpenseTimelineProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Блок общих расходов
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Расходы за месяц")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(entry.totalSpent, specifier: "%.0f") ₽")
                        .font(.title2)
                        .bold()
                }
                Spacer()
                Image(systemName: "chart.pie.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            
            Divider()

            // Блок последних транзакций
            VStack(alignment: .leading, spacing: 6) {
                Text("Последние")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                
                if entry.recentExpenses.isEmpty {
                    Text("Нет транзакций")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxHeight: .infinity)
                } else {
                    ForEach(entry.recentExpenses.prefix(3)) { expense in
                        HStack {
                            Text(expense.title)
                                .font(.subheadline)
                                .lineLimit(1)
                            Spacer()
                            Text("-\(expense.amount, specifier: "%.0f") ₽")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
