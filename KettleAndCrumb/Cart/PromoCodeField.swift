import SwiftUI

struct PromoCodeField: View {
    @Environment(AppModel.self) private var model

    @State private var code = ""
    @State private var isInvalid = false

    var body: some View {
        HStack(spacing: 10) {
            TextField("", text: $code, prompt: Text("Promo code"))
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isInvalid ? Color.red : Color(.separator), lineWidth: isInvalid ? 2 : 1)
                }
                .onChange(of: code) {
                    isInvalid = false
                }

            Button("Apply") {
                isInvalid = !model.applyPromoCode(code)
            }
            .buttonStyle(.bordered)
            .disabled(code.isEmpty)
        }
    }
}

#Preview {
    PromoCodeField()
        .padding()
        .environment(AppModel())
}
