import SwiftUI

struct CategoryPicker: View {
    
    @Binding var category : String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(ExpenseCategory.all) { category in
                    let isSelected = self.category == category.name
                    
                    VStack {
                        ZStack {
                            Circle()
                                .fill(isSelected ? category.color : Color.gray.opacity(0.1    ))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: category.icon)
                                .font(.title2)
                                .foregroundStyle(isSelected ? .white : .blue)
                        }
                        
                        Text(category.name)
                            .font(.caption)
                            .fontWeight(isSelected ? .bold : .regular)
                            .foregroundColor(isSelected ? category.color : .primary)
                    }
                    .onTapGesture {
                        withAnimation {
                            self.category = category.name
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var category = ExpenseCategory.all.first?.name ?? "Food"
    
    CategoryPicker(category: $category)
}
