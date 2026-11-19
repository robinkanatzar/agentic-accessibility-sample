import Foundation

nonisolated enum MenuCategory: String, CaseIterable, Identifiable, Sendable {
    case coffee = "Coffee"
    case tea = "Tea"
    case bakery = "Bakery"

    var id: String { rawValue }
}

nonisolated enum DietaryTag: String, CaseIterable, Identifiable, Sendable {
    case vegan
    case glutenFree
    case containsNuts

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vegan: "Vegan"
        case .glutenFree: "Gluten-free"
        case .containsNuts: "Contains nuts"
        }
    }
}

nonisolated enum DrinkSize: String, CaseIterable, Identifiable, Sendable {
    case small = "S"
    case medium = "M"
    case large = "L"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .small: "Small"
        case .medium: "Medium"
        case .large: "Large"
        }
    }

    var surcharge: Double {
        switch self {
        case .small: 0
        case .medium: 0.4
        case .large: 0.8
        }
    }
}

nonisolated enum MilkOption: String, CaseIterable, Identifiable, Sendable {
    case whole = "Whole"
    case oat = "Oat"
    case almond = "Almond"
    case soy = "Soy"

    var id: String { rawValue }

    var surcharge: Double {
        self == .whole ? 0 : 0.5
    }
}

nonisolated struct MenuItem: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let summary: String
    let category: MenuCategory
    let basePrice: Double
    let imageName: String
    let tags: [DietaryTag]
    var hasSizes = true
    var hasMilk = true
}
