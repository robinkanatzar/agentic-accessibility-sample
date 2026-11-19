import SwiftUI

struct RootView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var model = model

        TabView(selection: $model.selectedTab) {
            Tab("Home", systemImage: "house", value: AppTab.home) {
                HomeView()
            }
            Tab("Menu", systemImage: "cup.and.saucer", value: AppTab.menu) {
                MenuView()
            }
            Tab("Cart", systemImage: "bag", value: AppTab.cart) {
                CartView()
            }
            .badge(model.cartCount)
            Tab("Rewards", systemImage: "star", value: AppTab.rewards) {
                RewardsView()
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppModel())
}
