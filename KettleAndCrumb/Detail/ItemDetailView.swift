import SwiftUI

struct ItemDetailView: View {
    let item: MenuItem

    @Environment(AppModel.self) private var model

    @State private var size: DrinkSize = .medium
    @State private var milk: MilkOption = .whole
    @State private var quantity = 1
    @State private var showingAdded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .frame(maxWidth: .infinity)
                    .clipped()

                VStack(alignment: .leading, spacing: 24) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.title.bold())
                                .accessibilityAddTraits(.isHeader)
                            Text(item.summary)
                                .font(.body)
                        }
                        Spacer(minLength: 0)
                        Button {
                            model.toggleFavourite(item)
                        } label: {
                            Image(systemName: model.isFavourite(item) ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundStyle(Theme.accent)
                                .frame(width: 44, height: 44)
                        }
                    }

                    if item.hasSizes {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Size")
                                .font(.headline)
                                .accessibilityAddTraits(.isHeader)
                            HStack(spacing: 6) {
                                ForEach(DrinkSize.allCases) { option in
                                    OptionButton(title: option.rawValue, isSelected: size == option) {
                                        size = option
                                    }
                                }
                            }
                        }
                    }

                    if item.hasMilk {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Milk")
                                .font(.headline)
                                .accessibilityAddTraits(.isHeader)
                            HStack(spacing: 6) {
                                ForEach(MilkOption.allCases) { option in
                                    OptionButton(title: option.rawValue, isSelected: milk == option) {
                                        milk = option
                                    }
                                }
                            }
                        }
                    }

                    HStack {
                        Text("Quantity")
                            .font(.headline)
                        Spacer()
                        QuantityControl(quantity: $quantity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .background(Color.white)
        .foregroundColor(.black)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total")
                        .font(.caption)
                    Text(total.asPrice)
                        .font(.title3.bold())
                }
                .foregroundColor(.black)
                .accessibilityElement(children: .combine)

                Button("Add to cart") {
                    addToCart()
                }
                .buttonStyle(PrimaryButtonStyle())
                .accessibilityLabel("Submit order item")
            }
            .padding()
            .background(Color.white)
        }
        .overlay {
            if showingAdded {
                Label("Added to cart", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.black.opacity(0.8), in: Capsule())
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var total: Double {
        let unit = item.basePrice
            + (item.hasSizes ? size.surcharge : 0)
            + (item.hasMilk ? milk.surcharge : 0)
        return unit * Double(quantity)
    }

    private func addToCart() {
        model.add(
            item,
            size: item.hasSizes ? size : nil,
            milk: item.hasMilk ? milk : nil,
            quantity: quantity
        )
        withAnimation(.spring(duration: 0.3)) {
            showingAdded = true
        }
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation {
                showingAdded = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: SampleData.menu[0])
    }
    .environment(AppModel())
}
