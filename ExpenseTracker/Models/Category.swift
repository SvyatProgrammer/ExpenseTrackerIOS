import Foundation
import SwiftUI

struct ExpenseCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color : Color
}

extension ExpenseCategory {
    static let all = [
        ExpenseCategory(name: "Food", icon: "fork.knife", color: .yellow),
        ExpenseCategory(name: "Transport", icon: "car", color: .blue),
        ExpenseCategory(name: "Shopping", icon: "bag", color: .orange),
        ExpenseCategory(name: "Entertainment", icon: "film", color: .gray),
        ExpenseCategory(name: "Bills", icon: "doc.text", color: .green),
        ExpenseCategory(name: "Other", icon: "ellipsis", color: .purple)
    ]
}
