import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var model = model

        NavigationStack(path: $model.homePath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.system(size: 34, weight: .bold))
                            .accessibilityAddTraits(.isHeader)
                        Text("What can we get started for you?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    PromoCarousel(promos: SampleData.promos)

                    ShortcutRow()
                        .padding(.horizontal)

                    Image("divider_bean")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                        .frame(maxWidth: .infinity)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("How we roast")
                            .font(.title2.bold())
                            .accessibilityAddTraits(.isHeader)
                        RoastVideo()
                        Text("Every bag starts behind our counter. Watch a batch go from green bean to ready to brew.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    Button("View full menu") {
                        model.selectedTab = .menu
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Theme.page)
            .navigationTitle("Kettle & Crumb")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .orderStatus:
                    OrderStatusView()
                }
            }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default: return "Good evening"
        }
    }
}

#Preview {
    HomeView()
        .environment(AppModel())
}
