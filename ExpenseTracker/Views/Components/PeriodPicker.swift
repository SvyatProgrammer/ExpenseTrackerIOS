import SwiftUI

struct PeriodPicker : View {
    @Binding var selectedPeriod : TimePeriod
    @Binding var customStartDate : Date
    @Binding var customEndDate : Date
    
    var body: some View {
        Section() {
            Picker("Period", selection: $selectedPeriod) {
                Text("This Month").tag(TimePeriod.thisMonth)
                Text("Last Month").tag(TimePeriod.lastMonth)
                Text("All Time").tag(TimePeriod.allTime)
                Text("Custom").tag(TimePeriod.custom(startDate: customStartDate, endDate: customEndDate))
            }
            .pickerStyle(.segmented)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(
            EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        
        if case .custom = selectedPeriod {
            Section("Date interval") {
                DatePicker("From", selection: $customStartDate, displayedComponents: .date)
                    .onChange(of: customStartDate) { _, newDate in
                        selectedPeriod = .custom(startDate: newDate, endDate: customEndDate)
                    }
                DatePicker("To", selection: $customEndDate, in: customStartDate..., displayedComponents: .date)
                    .onChange(of: customEndDate) { _, newDate in
                        selectedPeriod = .custom(startDate: customStartDate, endDate: newDate)
                    }
            }
        }
    }
}
