import Foundation

nonisolated struct CartLine: Identifiable, Hashable, Sendable {
    let id = UUID()
    let item: MenuItem
    let size: DrinkSize?
    let milk: MilkOption?
    var quantity: Int

    var unitPrice: Double {
        item.basePrice + (size?.surcharge ?? 0) + (milk?.surcharge ?? 0)
    }

    var total: Double {
        unitPrice * Double(quantity)
    }

    var optionsSummary: String {
        var parts: [String] = []
        if let size { parts.append(size.title) }
        if let milk { parts.append("\(milk.rawValue.lowercased()) milk") }
        return parts.joined(separator: ", ")
    }
}

nonisolated enum OrderStage: Int, CaseIterable, Identifiable, Sendable {
    case received
    case preparing
    case ready

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .received: "Received"
        case .preparing: "Preparing"
        case .ready: "Ready"
        }
    }

    var message: String {
        switch self {
        case .received: "We've got your order"
        case .preparing: "Your order is being made"
        case .ready: "Ready for pickup at the counter"
        }
    }
}

nonisolated struct Order: Identifiable, Sendable {
    let id = UUID()
    let number: Int
    let lines: [CartLine]
    let total: Double
    let customerName: String
    let pickupTime: String
    var stage: OrderStage = .received
}

nonisolated enum HomeRoute: Hashable, Sendable {
    case orderStatus
}

nonisolated enum CartRoute: Hashable, Sendable {
    case checkout
    case orderStatus
}

nonisolated enum AppTab: Hashable, Sendable {
    case home
    case menu
    case cart
    case rewards
}
