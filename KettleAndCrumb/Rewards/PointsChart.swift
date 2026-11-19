import SwiftUI

struct PointsChart: View {
    let months: [MonthPoints]

    var body: some View {
        Canvas { context, size in
            let labelHeight: CGFloat = 26
            let chartHeight = size.height - labelHeight
            let peak = CGFloat(max(months.map { max($0.earned, $0.redeemed) }.max() ?? 1, 1))
            let groupWidth = size.width / CGFloat(max(months.count, 1))
            let barWidth = min(16, groupWidth * 0.3)

            for line in 0...3 {
                let y = chartHeight * CGFloat(line) / 3
                var grid = Path()
                grid.move(to: CGPoint(x: 0, y: y))
                grid.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(grid, with: .color(Color(.separator)), lineWidth: 1)
            }

            for (index, month) in months.enumerated() {
                let center = groupWidth * (CGFloat(index) + 0.5)

                let earnedHeight = chartHeight * CGFloat(month.earned) / peak
                let earned = CGRect(x: center - barWidth - 2, y: chartHeight - earnedHeight, width: barWidth, height: earnedHeight)
                context.fill(Path(roundedRect: earned, cornerRadius: 4), with: .color(Theme.chartEarned))

                let redeemedHeight = chartHeight * CGFloat(month.redeemed) / peak
                let redeemed = CGRect(x: center + 2, y: chartHeight - redeemedHeight, width: barWidth, height: redeemedHeight)
                context.fill(Path(roundedRect: redeemed, cornerRadius: 4), with: .color(Theme.chartRedeemed))

                let label = context.resolve(Text(month.month).font(.caption).foregroundStyle(.secondary))
                context.draw(label, at: CGPoint(x: center, y: size.height - labelHeight / 2 + 4))
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

#Preview {
    PointsChart(months: SampleData.monthlyPoints)
        .frame(height: 190)
        .padding()
}
