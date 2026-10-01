import Foundation
import SwiftData

@Model
final class Expense {
    var amount : Double
    var title : String
    var category : String
    var date : Date
    
    init(amount: Double, title: String, category: String, date: Date) {
        self.amount = amount
        self.title = title
        self.category = category
        self.date = date
    }
}
