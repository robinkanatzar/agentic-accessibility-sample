import SwiftUI

enum Theme {
    static let accent = Color("AccentColor")
    static let onAccent = Color("OnAccent")
    static let page = Color(.systemGroupedBackground)
    static let card = Color(.secondarySystemGroupedBackground)
    static let priceText = Color(red: 0.76, green: 0.76, blue: 0.78)
    static let tierGold = Color(red: 0.89, green: 0.70, blue: 0.25)
    static let chartEarned = Color(red: 0.75, green: 0.40, blue: 0.18)
    static let chartRedeemed = Color(red: 0.18, green: 0.55, blue: 0.55)
    static let cornerRadius: CGFloat = 16
}

extension DietaryTag {
    var color: Color {
        switch self {
        case .vegan: .green
        case .glutenFree: .purple
        case .containsNuts: .orange
        }
    }
}

extension Double {
    var asPrice: String {
        formatted(.currency(code: "GBP"))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Theme.onAccent)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension View {
    func card() -> some View {
        self
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}
