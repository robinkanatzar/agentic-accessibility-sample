import Foundation

nonisolated enum SampleData {
    static let promos: [Promo] = [
        Promo(id: 1, imageName: "promo_01"),
        Promo(id: 2, imageName: "promo_02"),
        Promo(id: 3, imageName: "promo_03")
    ]

    static let menu: [MenuItem] = [
        MenuItem(
            id: "flat-white",
            name: "Flat white",
            summary: "Two shots of our house espresso under a thin layer of silky steamed milk.",
            category: .coffee,
            basePrice: 3.4,
            imageName: "menu_flatwhite_01",
            tags: [.glutenFree]
        ),
        MenuItem(
            id: "cappuccino",
            name: "Cappuccino",
            summary: "Espresso, steamed milk and a deep cap of foam, finished with cocoa.",
            category: .coffee,
            basePrice: 3.4,
            imageName: "menu_cappuccino_01",
            tags: [.glutenFree]
        ),
        MenuItem(
            id: "espresso",
            name: "Espresso",
            summary: "A short, sweet shot of this week's single origin roast.",
            category: .coffee,
            basePrice: 2.4,
            imageName: "menu_espresso_01",
            tags: [.vegan, .glutenFree],
            hasSizes: false,
            hasMilk: false
        ),
        MenuItem(
            id: "cold-brew",
            name: "Slow-steeped cold brew",
            summary: "Steeped for eighteen hours and served over ice. Smooth, chocolatey and strong.",
            category: .coffee,
            basePrice: 3.6,
            imageName: "menu_coldbrew_01",
            tags: [.vegan, .glutenFree],
            hasMilk: false
        ),
        MenuItem(
            id: "matcha-latte",
            name: "Matcha latte",
            summary: "Ceremonial grade matcha whisked by hand and topped with steamed milk.",
            category: .tea,
            basePrice: 3.9,
            imageName: "menu_matcha_01",
            tags: [.glutenFree]
        ),
        MenuItem(
            id: "chai-latte",
            name: "Spiced chai latte",
            summary: "Black tea simmered with cardamom, cinnamon, ginger and star anise.",
            category: .tea,
            basePrice: 3.7,
            imageName: "menu_chai_01",
            tags: [.glutenFree]
        ),
        MenuItem(
            id: "earl-grey",
            name: "Earl Grey",
            summary: "Loose leaf black tea with bergamot, served with a slice of lemon.",
            category: .tea,
            basePrice: 2.8,
            imageName: "menu_earlgrey_01",
            tags: [.vegan, .glutenFree],
            hasMilk: false
        ),
        MenuItem(
            id: "cinnamon-swirl",
            name: "Cardamom and cinnamon swirl",
            summary: "Soft, buttery dough rolled with spiced sugar and finished with vanilla icing.",
            category: .bakery,
            basePrice: 3.2,
            imageName: "menu_swirl_01",
            tags: [],
            hasSizes: false,
            hasMilk: false
        ),
        MenuItem(
            id: "cookie",
            name: "Brown butter chocolate chip cookie",
            summary: "Crisp at the edge, soft in the middle, with dark chocolate and sea salt.",
            category: .bakery,
            basePrice: 2.6,
            imageName: "menu_cookie_01",
            tags: [.containsNuts],
            hasSizes: false,
            hasMilk: false
        ),
        MenuItem(
            id: "muffin",
            name: "Blueberry oat muffin",
            summary: "Baked every morning with whole blueberries and a crunchy oat top.",
            category: .bakery,
            basePrice: 2.9,
            imageName: "menu_muffin_01",
            tags: [.vegan],
            hasSizes: false,
            hasMilk: false
        ),
        MenuItem(
            id: "bagel",
            name: "Toasted sesame bagel",
            summary: "Boiled, baked and toasted to order. Served with butter or cream cheese.",
            category: .bakery,
            basePrice: 2.5,
            imageName: "menu_bagel_01",
            tags: [.vegan],
            hasSizes: false,
            hasMilk: false
        ),
        MenuItem(
            id: "brownie",
            name: "Almond fudge brownie",
            summary: "Dense, dark and made with ground almonds instead of flour.",
            category: .bakery,
            basePrice: 3.0,
            imageName: "menu_brownie_01",
            tags: [.glutenFree, .containsNuts],
            hasSizes: false,
            hasMilk: false
        )
    ]

    static let pointsBalance = 340
    static let nextTierPoints = 500

    static let monthlyPoints: [MonthPoints] = [
        MonthPoints(month: "Jun", earned: 42, redeemed: 0),
        MonthPoints(month: "Jul", earned: 58, redeemed: 20),
        MonthPoints(month: "Aug", earned: 35, redeemed: 0),
        MonthPoints(month: "Sep", earned: 74, redeemed: 50),
        MonthPoints(month: "Oct", earned: 66, redeemed: 0),
        MonthPoints(month: "Nov", earned: 81, redeemed: 30)
    ]

    static let pointsHistory: [PointsEntry] = [
        PointsEntry(title: "Flat white and cinnamon swirl", date: date(2026, 11, 17), points: 13),
        PointsEntry(title: "Free pastry reward", date: date(2026, 11, 14), points: -30),
        PointsEntry(title: "Double points Friday", date: date(2026, 11, 13), points: 24),
        PointsEntry(title: "Matcha latte", date: date(2026, 11, 9), points: 8),
        PointsEntry(title: "Cappuccino and cookie", date: date(2026, 11, 3), points: 12),
        PointsEntry(title: "Cold brew", date: date(2026, 10, 28), points: 7)
    ]

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? .now
    }
}
