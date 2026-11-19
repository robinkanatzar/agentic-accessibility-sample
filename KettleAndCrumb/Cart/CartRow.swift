import SwiftUI

struct CartRow: View {
    let line: CartLine
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0

    private let deleteThreshold: CGFloat = 110

    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .fill(Color.red)
                .opacity(offset < 0 ? 1 : 0)
            Image(systemName: "trash.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(.trailing, 24)
                .opacity(offset < 0 ? 1 : 0)

            HStack(spacing: 12) {
                Image(decorative: line.item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(line.item.name)
                        .font(.headline)
                    if !line.optionsSummary.isEmpty {
                        Text(line.optionsSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Text("Quantity: \(line.quantity)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Text(line.total.asPrice)
                    .font(.headline)
            }
            .padding(12)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .accessibilityElement(children: .combine)
            .offset(x: offset)
            .simultaneousGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        guard abs(value.translation.width) > abs(value.translation.height) else { return }
                        offset = min(0, value.translation.width)
                    }
                    .onEnded { value in
                        if value.translation.width < -deleteThreshold {
                            onDelete()
                        } else {
                            withAnimation(.spring(duration: 0.3)) {
                                offset = 0
                            }
                        }
                    }
            )
        }
    }
}

#Preview {
    CartRow(line: CartLine(item: SampleData.menu[0], size: .medium, milk: .oat, quantity: 2)) {}
        .padding()
        .background(Theme.page)
}
