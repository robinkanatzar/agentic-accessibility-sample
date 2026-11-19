import SwiftUI

struct MenuFilters: Equatable {
    var veganOnly = false
    var glutenFreeOnly = false
    var hideNuts = false
    var favouritesOnly = false
}

struct MenuView: View {
    @Environment(AppModel.self) private var model

    @State private var category: MenuCategory?
    @State private var filters = MenuFilters()
    @State private var showingFilters = false

    var body: some View {
        @Bindable var model = model

        NavigationStack(path: $model.menuPath) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    CategoryChips(selection: $category)

                    ForEach(items) { item in
                        MenuItemCard(item: item)
                            .onTapGesture {
                                model.menuPath.append(item)
                            }
                    }
                    .padding(.horizontal)

                    if items.isEmpty {
                        ContentUnavailableView(
                            "Nothing matches",
                            systemImage: "magnifyingglass",
                            description: Text("Try changing your filters.")
                        )
                        .padding(.top, 40)
                    }
                }
                .padding(.vertical)
            }
            .background(Theme.page)
            .navigationTitle("Menu")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterSheet(filters: $filters)
            }
            .navigationDestination(for: MenuItem.self) { item in
                ItemDetailView(item: item)
            }
        }
    }

    private var items: [MenuItem] {
        SampleData.menu.filter { item in
            if let category, item.category != category { return false }
            if filters.veganOnly, !item.tags.contains(.vegan) { return false }
            if filters.glutenFreeOnly, !item.tags.contains(.glutenFree) { return false }
            if filters.hideNuts, item.tags.contains(.containsNuts) { return false }
            if filters.favouritesOnly, !model.isFavourite(item) { return false }
            return true
        }
    }
}

#Preview {
    MenuView()
        .environment(AppModel())
}
