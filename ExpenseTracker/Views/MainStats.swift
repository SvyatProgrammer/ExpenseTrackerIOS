import SwiftUI

struct MainStats : View {
    
    let totalSpent : Double
    let averageSpent : Double
    let biggestSpent : Double
    
    @AppStorage("currency") private var currency = "USD"
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Total spent")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(formatCurrency(totalSpent, currency: currency))
                        .font(.system(size: 40, weight: .bold))
                }
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("AVR")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(formatCurrency(averageSpent, currency: currency))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("Biggest spent")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(formatCurrency(biggestSpent, currency: currency))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 8)
        }
    }
}
