import SwiftUI

struct OrderStatusView: View {
    @Environment(AppModel.self) private var model

    @State private var showingToast = false

    var body: some View {
        Group {
            if let order = model.activeOrder {
                content(for: order)
            } else {
                ContentUnavailableView {
                    Label("No active order", systemImage: "cup.and.saucer")
                } description: {
                    Text("Place an order and you can follow it here.")
                } actions: {
                    Button("Browse the menu") {
                        model.selectedTab = .menu
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.page)
        .navigationTitle("Your order")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .top) {
            if showingToast {
                Label("Your order is ready!", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(Theme.onAccent)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Theme.accent, in: Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: model.activeOrder?.stage) { _, stage in
            guard stage == .ready else { return }
            withAnimation(.spring(duration: 0.4)) {
                showingToast = true
            }
            Task {
                try? await Task.sleep(for: .seconds(2))
                withAnimation {
                    showingToast = false
                }
            }
        }
    }

    private func content(for order: Order) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                SteamingCup()
                    .frame(height: 170)
                    .padding(.top, 8)

                Text(order.stage.message)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                StageTrack(stage: order.stage)

                VStack(alignment: .leading, spacing: 12) {
                    LabeledContent("Order", value: "#\(order.number)")
                    LabeledContent("Name", value: order.customerName)
                    LabeledContent("Pickup", value: order.pickupTime)
                    Divider()
                    ForEach(order.lines) { line in
                        LabeledContent("\(line.quantity) × \(line.item.name)", value: line.total.asPrice)
                    }
                    Divider()
                    LabeledContent("Total", value: order.total.asPrice)
                        .font(.headline)
                }
                .card()
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        OrderStatusView()
    }
    .environment(AppModel())
}
