import WidgetKit

struct WidgetExpenseItem : Identifiable, Codable {
    let id : UUID
    let title : String
    let amount : Double
    let categoryName : String
}
