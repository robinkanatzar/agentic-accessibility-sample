import SwiftUI

struct FilterSheet: View {
    @Binding var filters: MenuFilters
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Dietary") {
                    Toggle(isOn: $filters.veganOnly) {
                        tagLabel("Vegan only", tag: .vegan)
                    }
                    Toggle(isOn: $filters.glutenFreeOnly) {
                        tagLabel("Gluten-free only", tag: .glutenFree)
                    }
                    Toggle(isOn: $filters.hideNuts) {
                        tagLabel("Hide items with nuts", tag: .containsNuts)
                    }
                }
                Section("Favourites") {
                    Toggle("Favourites only", isOn: $filters.favouritesOnly)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        filters = MenuFilters()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func tagLabel(_ title: String, tag: DietaryTag) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(tag.color)
                .frame(width: 10, height: 10)
            Text(title)
        }
    }
}

#Preview {
    FilterSheet(filters: .constant(MenuFilters()))
}
