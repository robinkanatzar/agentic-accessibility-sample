import SwiftUI

struct PromoCarousel: View {
    let promos: [Promo]

    @State private var index = 0

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(promos.enumerated()), id: \.element.id) { position, promo in
                Image(promo.imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .padding(.horizontal)
                    .tag(position)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .aspectRatio(2, contentMode: .fit)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                withAnimation(.easeInOut(duration: 0.6)) {
                    index = (index + 1) % promos.count
                }
            }
        }
    }
}

#Preview {
    PromoCarousel(promos: SampleData.promos)
}
