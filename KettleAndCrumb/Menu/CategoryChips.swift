import SwiftUI

struct CategoryChips: View {
    @Binding var selection: MenuCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: "All", category: nil)
                ForEach(MenuCategory.allCases) { category in
                    chip(title: category.rawValue, category: category)
                }
            }
            .padding(.horizontal)
        }
    }

    private func chip(title: String, category: MenuCategory?) -> some View {
        let isSelected = selection == category

        return Button {
            selection = category
        } label: {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .foregroundStyle(isSelected ? Theme.onAccent : Color.primary)
                .background(isSelected ? Theme.accent : Color(.tertiarySystemFill), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    CategoryChips(selection: .constant(.coffee))
}
