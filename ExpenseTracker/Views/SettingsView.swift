import SwiftUI

struct SettingsView: View {
    
    @AppStorage("currency") private var currency = "USD"
    
    let currencies = [
        "USD",
        "EUR",
        "BLR"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Currency") {
                    Picker("Currency", selection: $currency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
