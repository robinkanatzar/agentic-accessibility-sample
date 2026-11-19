import UIKit

final class PickupTimeControl: UIView {
    private(set) var slots: [String] = []
    private(set) var selectedIndex = 0

    var selectedSlot: String {
        slots[selectedIndex]
    }

    private let spacing: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
        slots = Self.makeSlots()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 48)
    }

    override func draw(_ rect: CGRect) {
        let accent = UIColor(named: "AccentColor") ?? .systemBrown
        let onAccent = UIColor(named: "OnAccent") ?? .white

        for (index, slot) in slots.enumerated() {
            let frame = slotFrame(at: index).insetBy(dx: 1, dy: 1)
            let path = UIBezierPath(roundedRect: frame, cornerRadius: 10)
            let isSelected = index == selectedIndex

            if isSelected {
                accent.setFill()
                path.fill()
            } else {
                UIColor.secondarySystemGroupedBackground.setFill()
                path.fill()
                UIColor.systemGray2.setStroke()
                path.lineWidth = 1
                path.stroke()
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15, weight: isSelected ? .semibold : .regular),
                .foregroundColor: isSelected ? onAccent : UIColor.label
            ]
            let text = NSAttributedString(string: slot, attributes: attributes)
            let size = text.size()
            text.draw(at: CGPoint(x: frame.midX - size.width / 2, y: frame.midY - size.height / 2))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        for index in slots.indices where slotFrame(at: index).contains(point) {
            selectedIndex = index
            setNeedsDisplay()
        }
    }

    private func slotFrame(at index: Int) -> CGRect {
        let count = CGFloat(slots.count)
        let width = (bounds.width - spacing * (count - 1)) / count
        return CGRect(x: CGFloat(index) * (width + spacing), y: 0, width: width, height: bounds.height)
    }

    private static func makeSlots() -> [String] {
        let calendar = Calendar.current
        let now = Date()
        let minute = calendar.component(.minute, from: now)
        let toNextQuarter = 15 - (minute % 15)
        let first = calendar.date(byAdding: .minute, value: toNextQuarter + 15, to: now) ?? now

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        var result = ["ASAP"]
        for step in 0..<3 {
            let date = calendar.date(byAdding: .minute, value: step * 15, to: first) ?? first
            result.append(formatter.string(from: date))
        }
        return result
    }
}
