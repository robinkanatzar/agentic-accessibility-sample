import SwiftUI

struct RewardsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    balanceCard
                    chartCard
                    historyCard
                }
                .padding()
            }
            .background(Theme.page)
            .navigationTitle("Rewards")
        }
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(model.pointsBalance)")
                    .font(.largeTitle.bold())
                Text("points")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)

            Text("Gold member")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.tierGold)

            ProgressView(value: Double(min(model.pointsBalance, SampleData.nextTierPoints)), total: Double(SampleData.nextTierPoints)) {
                Text("\(max(SampleData.nextTierPoints - model.pointsBalance, 0)) points to Platinum")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .tint(Theme.accent)
        }
        .card()
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last six months")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            PointsChart(months: SampleData.monthlyPoints)
                .frame(height: 190)

            HStack(spacing: 16) {
                legend("Earned", color: Theme.chartEarned)
                legend("Redeemed", color: Theme.chartRedeemed)
            }
        }
        .card()
    }

    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent activity")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            ForEach(model.pointsHistory) { entry in
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.title)
                            .font(.body)
                        Text(entry.dateText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 12)
                    Text(entry.pointsText)
                        .font(.body.monospacedDigit())
                }
                .accessibilityElement(children: .combine)

                if entry.id != model.pointsHistory.last?.id {
                    Divider()
                }
            }
        }
        .card()
    }

    private func legend(_ title: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    RewardsView()
        .environment(AppModel())
}
