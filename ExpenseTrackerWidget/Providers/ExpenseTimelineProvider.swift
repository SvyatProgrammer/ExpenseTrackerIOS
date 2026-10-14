import WidgetKit

struct ExpenseTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ExpenseEntry {
        ExpenseEntry(date: Date(), totalSpent: 12500.0, recentExpenses: [
            .init(id: UUID(), title: "Кофе", amount: 350.0, categoryName: "Еда"),
            .init(id: UUID(), title: "Такси", amount: 800.0, categoryName: "Транспорт")
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (ExpenseEntry) -> Void) {
        let entry = loadData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ExpenseEntry>) -> Void) {
        let entry = loadData()
        // Обновляем виджет, например, каждый час или принудительно из приложения
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func loadData() -> ExpenseEntry {
        // Читаем из UserDefaults(suiteName: "group.com.yourname.ExpenseTracker")
        let defaults = UserDefaults(suiteName: "group.com.yourname.ExpenseTracker")
        
        let total = defaults?.double(forKey: "widget_total_spent") ?? 0.0
        // Здесь также считывается и декодируется массив транзакций из JSON
        
        return ExpenseEntry(date: Date(), totalSpent: total, recentExpenses: [])
    }
}
