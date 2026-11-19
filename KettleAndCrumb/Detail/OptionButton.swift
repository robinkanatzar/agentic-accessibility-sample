import SwiftUI

struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .accessibilityHidden(true)
                }
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
            }
            .frame(width: 80, height: 44)
            .background(
                isSelected ? Theme.accent.opacity(0.12) : Color.clear,
                in: RoundedRectangle(cornerRadius: 10)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Theme.accent : Color.gray.opacity(0.6), lineWidth: isSelected ? 2 : 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack {
        OptionButton(title: "Oat", isSelected: true) {}
        OptionButton(title: "Almond", isSelected: false) {}
    }
}
