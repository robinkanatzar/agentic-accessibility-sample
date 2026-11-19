import SwiftUI

struct ShortcutRow: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(spacing: 12))

        layout {
            ShortcutTile(title: "Order now", systemImage: "cup.and.saucer.fill")
                .onTapGesture {
                    model.selectedTab = .menu
                }
            ShortcutTile(title: "Your order", systemImage: "clock.fill")
                .onTapGesture {
                    model.homePath.append(.orderStatus)
                }
            ShortcutTile(title: "Rewards", systemImage: "star.fill")
                .onTapGesture {
                    model.selectedTab = .rewards
                }
        }
    }
}

struct ShortcutTile: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Theme.accent)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .contentShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}

#Preview {
    ShortcutRow()
        .padding()
        .environment(AppModel())
}
