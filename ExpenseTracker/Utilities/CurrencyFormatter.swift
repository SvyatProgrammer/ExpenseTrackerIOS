import Foundation

func formatCurrency(_ amount : Double, currency : String) -> String {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    formatter.currencyCode = currency
    
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
}
