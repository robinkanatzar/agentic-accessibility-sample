import Foundation

nonisolated struct MonthPoints: Identifiable, Sendable {
    let month: String
    let earned: Int
    let redeemed: Int

    var id: String { month }
}

nonisolated struct PointsEntry: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let date: Date
    let points: Int

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }

    var pointsText: String {
        points >= 0 ? "+\(points) pts" : "−\(abs(points)) pts"
    }
}

nonisolated struct Promo: Identifiable, Sendable {
    let id: Int
    let imageName: String
}
