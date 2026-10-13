enum Currencies : String, CaseIterable, Identifiable {
    case usd
    case eur
    case blr
    
    var id : String { self.rawValue }
    
    var title : String {
        switch self {
        case .usd: return "USD"
        case .eur: return "EUR"
        case .blr: return "BYN"
        }
    }
}
