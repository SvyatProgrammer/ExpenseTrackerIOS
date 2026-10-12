import SwiftUI

struct SettingsView: View {
    
    @AppStorage("currency") private var currency = "USD"
    @AppStorage("appTheme") private var appTheme = "system"
    
    let currencies = [
        "USD",
        "EUR",
        "BLR"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Main") {
                    Picker("Currency", selection: $currency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
                Section("Personalities") {
                    Picker("Theme", selection: $appTheme) {
                        Text("System").tag("system")
                        Text("Dark").tag("dark")
                        Text("Light").tag("light")
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
