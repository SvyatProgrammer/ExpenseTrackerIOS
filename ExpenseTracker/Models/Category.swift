import Foundation

struct ExpenseCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

extension ExpenseCategory {
    static let all = [
        ExpenseCategory(name: "Food", icon: "fork.knife"),
        ExpenseCategory(name: "Transport", icon: "car"),
        ExpenseCategory(name: "Shopping", icon: "bag"),
        ExpenseCategory(name: "Entertainment", icon: "film"),
        ExpenseCategory(name: "Bills", icon: "doc.text"),
        ExpenseCategory(name: "Other", icon: "ellipsis")
    ]
}
