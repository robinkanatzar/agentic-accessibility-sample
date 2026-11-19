import SwiftUI

struct StageTrack: View {
    let stage: OrderStage

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private let dotSize: CGFloat = 24

    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { proxy in
                let span = proxy.size.width - dotSize
                let steps = CGFloat(OrderStage.allCases.count - 1)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray4))
                        .frame(height: 6)
                        .padding(.horizontal, dotSize / 2)
                    Capsule()
                        .fill(Color.green)
                        .frame(width: span * CGFloat(stage.rawValue) / steps, height: 6)
                        .padding(.leading, dotSize / 2)
                    ForEach(OrderStage.allCases) { step in
                        Circle()
                            .fill(color(for: step))
                            .frame(width: dotSize, height: dotSize)
                            .offset(x: span * CGFloat(step.rawValue) / steps)
                    }
                }
                .frame(height: dotSize)
            }
            .frame(height: dotSize)
            .animation(.easeInOut(duration: 0.8), value: stage)

            if dynamicTypeSize.isAccessibilitySize {
                Text(OrderStage.allCases.map(\.title).joined(separator: " → "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack {
                    Text(OrderStage.received.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(OrderStage.preparing.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(OrderStage.ready.title)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }

    private func color(for step: OrderStage) -> Color {
        if step.rawValue < stage.rawValue {
            return .green
        }
        if step == stage {
            return .orange
        }
        return Color(.systemGray3)
    }
}

#Preview {
    StageTrack(stage: .preparing)
        .padding()
}
