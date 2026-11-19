import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)
                Text(item.basePrice.asPrice)
                    .font(.subheadline)
                    .foregroundStyle(Theme.priceText)
            }

            Spacer(minLength: 8)

            HStack(spacing: 4) {
                ForEach(item.tags) { tag in
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(tag.color)
                }
            }
        }
        .padding(12)
        .frame(height: 92)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .contentShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}

#Preview {
    VStack {
        MenuItemCard(item: SampleData.menu[0])
        MenuItemCard(item: SampleData.menu[8])
    }
    .padding()
    .background(Theme.page)
}
