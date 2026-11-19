import SwiftUI

struct CheckoutScreen: UIViewControllerRepresentable {
    let total: Double
    let onComplete: (String, String) -> Void

    func makeUIViewController(context: Context) -> CheckoutViewController {
        CheckoutViewController(total: total, onComplete: onComplete)
    }

    func updateUIViewController(_ controller: CheckoutViewController, context: Context) {}
}
