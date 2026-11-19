import SwiftUI

struct CartTotals: View {
    let subtotal: Double
    let discount: Double
    let total: Double

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Subtotal")
                if discount > 0 {
                    Text("Discount")
                }
                Text("Total")
                    .font(.headline)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 10) {
                Text(subtotal.asPrice)
                if discount > 0 {
                    Text("−\(discount.asPrice)")
                }
                Text(total.asPrice)
                    .font(.headline)
            }
        }
        .card()
    }
}

#Preview {
    CartTotals(subtotal: 12.4, discount: 1.24, total: 11.16)
        .padding()
        .background(Theme.page)
}
