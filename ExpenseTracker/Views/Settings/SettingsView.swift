import SwiftUI

struct SettingsView: View {
    
    @AppStorage("currency") private var currency : String = Currencies.usd.rawValue
    @AppStorage("appTheme") private var appTheme = "system"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Main") {
                    Picker("Currency", selection: $currency) {
                        ForEach(Currencies.allCases) { currency in
                            Text(currency.title).tag(currency.title)
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
