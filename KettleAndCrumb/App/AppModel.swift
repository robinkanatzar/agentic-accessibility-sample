import Foundation
import Observation

@Observable
final class AppModel {
    var selectedTab: AppTab = .home
    var homePath: [HomeRoute] = []
    var menuPath: [MenuItem] = []
    var cartPath: [CartRoute] = []

    var cart: [CartLine] = []
    var favourites: Set<String> = []
    var discountRate: Double = 0
    var activeOrder: Order?

    var pointsBalance = SampleData.pointsBalance
    var pointsHistory = SampleData.pointsHistory

    private var nextOrderNumber = 214
    private var progressTask: Task<Void, Never>?

    var cartCount: Int {
        cart.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Double {
        cart.reduce(0) { $0 + $1.total }
    }

    var discount: Double {
        subtotal * discountRate
    }

    var total: Double {
        subtotal - discount
    }

    func add(_ item: MenuItem, size: DrinkSize?, milk: MilkOption?, quantity: Int) {
        if let index = cart.firstIndex(where: { $0.item == item && $0.size == size && $0.milk == milk }) {
            cart[index].quantity += quantity
        } else {
            cart.append(CartLine(item: item, size: size, milk: milk, quantity: quantity))
        }
    }

    func remove(_ line: CartLine) {
        cart.removeAll { $0.id == line.id }
        if cart.isEmpty {
            discountRate = 0
        }
    }

    func isFavourite(_ item: MenuItem) -> Bool {
        favourites.contains(item.id)
    }

    func toggleFavourite(_ item: MenuItem) {
        if favourites.contains(item.id) {
            favourites.remove(item.id)
        } else {
            favourites.insert(item.id)
        }
    }

    func applyPromoCode(_ code: String) -> Bool {
        let cleaned = code.trimmingCharacters(in: .whitespaces).uppercased()
        guard cleaned == "CRUMB10" else {
            discountRate = 0
            return false
        }
        discountRate = 0.1
        return true
    }

    func placeOrder(name: String, pickupTime: String) {
        let order = Order(
            number: nextOrderNumber,
            lines: cart,
            total: total,
            customerName: name,
            pickupTime: pickupTime
        )
        let earned = Int(total.rounded())
        let title = cart.map(\.item.name).prefix(2).joined(separator: " and ")
        pointsBalance += earned
        pointsHistory.insert(PointsEntry(title: title, date: .now, points: earned), at: 0)

        nextOrderNumber += 1
        activeOrder = order
        cart = []
        discountRate = 0
        followProgress()
    }

    private func followProgress() {
        progressTask?.cancel()
        progressTask = Task {
            try? await Task.sleep(for: .seconds(10))
            guard !Task.isCancelled else { return }
            activeOrder?.stage = .preparing
            try? await Task.sleep(for: .seconds(10))
            guard !Task.isCancelled else { return }
            activeOrder?.stage = .ready
        }
    }
}
