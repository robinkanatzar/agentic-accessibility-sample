import SwiftUI

struct SteamingCup: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ForEach(0..<3, id: \.self) { index in
                    SteamWisp(phase: phase + CGFloat(index) * 0.33)
                        .stroke(
                            LinearGradient(
                                colors: [Color.secondary.opacity(0), Color.secondary.opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 18, height: 60)
                }
            }
            .padding(.trailing, 22)

            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 96))
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

nonisolated struct SteamWisp: Shape {
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let steps = 40
        for step in 0...steps {
            let progress = CGFloat(step) / CGFloat(steps)
            let y = rect.maxY - progress * rect.height
            let wave = sin((progress * 2 + phase * 2) * .pi)
            let x = rect.midX + wave * rect.width * 0.35 * progress
            if step == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

#Preview {
    SteamingCup()
        .frame(height: 170)
}
