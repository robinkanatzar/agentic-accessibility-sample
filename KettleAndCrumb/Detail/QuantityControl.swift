import SwiftUI

struct QuantityControl: View {
    @Binding var quantity: Int

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "minus.circle")
                .font(.largeTitle)
                .foregroundStyle(Theme.accent)
                .onTapGesture {
                    if quantity > 1 {
                        quantity -= 1
                    }
                }

            Text("\(quantity)")
                .font(.title2.monospacedDigit().weight(.semibold))
                .frame(minWidth: 32)

            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(Theme.accent)
                .onTapGesture {
                    if quantity < 9 {
                        quantity += 1
                    }
                }
        }
    }
}

#Preview {
    QuantityControl(quantity: .constant(2))
}
