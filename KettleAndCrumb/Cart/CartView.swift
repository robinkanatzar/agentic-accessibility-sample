import SwiftUI

struct CartView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var model = model

        NavigationStack(path: $model.cartPath) {
            Group {
                if model.cart.isEmpty {
                    emptyState
                } else {
                    content
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.page)
            .navigationTitle("Cart")
            .navigationDestination(for: CartRoute.self) { route in
                switch route {
                case .checkout:
                    CheckoutScreen(total: model.total) { name, pickupTime in
                        model.placeOrder(name: name, pickupTime: pickupTime)
                        model.cartPath = [.orderStatus]
                    }
                    .ignoresSafeArea(.keyboard)
                    .navigationTitle("Checkout")
                    .navigationBarTitleDisplayMode(.inline)
                case .orderStatus:
                    OrderStatusView()
                }
            }
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    ForEach(model.cart) { line in
                        CartRow(line: line) {
                            withAnimation {
                                model.remove(line)
                            }
                        }
                    }
                }

                Text("Swipe left on an item to remove it.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                PromoCodeField()

                CartTotals(subtotal: model.subtotal, discount: model.discount, total: model.total)

                Button("Checkout") {
                    model.cartPath.append(.checkout)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
    }

    private var emptyState: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image("cart_empty")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 220)
                Text("Your cart is empty")
                    .font(.title2.bold())
                Text("Add something delicious from the menu and it will show up here.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Browse the menu") {
                    model.selectedTab = .menu
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 8)
            }
            .padding(24)
        }
    }
}

#Preview {
    CartView()
        .environment(AppModel())
}
