import UIKit

final class CheckoutViewController: UIViewController {
    private let total: Double
    private let onComplete: (String, String) -> Void

    private let scrollView = UIScrollView()
    private let formStack = UIStackView()

    private let pickupControl = PickupTimeControl()
    private let nameField = UITextField()
    private let cardField = UITextField()
    private let expiryField = UITextField()
    private let cvcField = UITextField()

    private let nameError = UILabel()
    private let cardError = UILabel()
    private let expiryError = UILabel()
    private let cvcError = UILabel()

    private let payButton = UIButton(type: .system)

    private var clearTask: Task<Void, Never>?

    init(total: Double, onComplete: @escaping (String, String) -> Void) {
        self.total = total
        self.onComplete = onComplete
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        buildLayout()
        updatePayButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        clearTask?.cancel()
        clearTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(60))
            guard !Task.isCancelled else { return }
            self?.clearCardDetails()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearTask?.cancel()
    }

    private func buildLayout() {
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        formStack.axis = .vertical
        formStack.spacing = 6
        formStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(formStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            formStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            formStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        let summary = makeSummary()
        formStack.addArrangedSubview(summary)
        formStack.setCustomSpacing(24, after: summary)

        formStack.addArrangedSubview(makeTitle("Pickup time"))
        formStack.addArrangedSubview(pickupControl)
        formStack.setCustomSpacing(20, after: pickupControl)

        configure(nameField, placeholder: "Alex", label: "Name for the order")
        nameField.textContentType = .givenName
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .next
        configure(nameError)
        formStack.addArrangedSubview(makeTitle("Name for the order"))
        formStack.addArrangedSubview(nameField)
        formStack.addArrangedSubview(nameError)
        formStack.setCustomSpacing(20, after: nameError)

        configure(cardField, placeholder: "1234 5678 9012 3456", label: "Card number")
        cardField.keyboardType = .numberPad
        cardField.textContentType = .creditCardNumber
        configure(cardError)
        formStack.addArrangedSubview(makeTitle("Card number"))
        formStack.addArrangedSubview(cardField)
        formStack.addArrangedSubview(cardError)
        formStack.setCustomSpacing(20, after: cardError)

        configure(expiryField, placeholder: "MM/YY", label: "Expiry date")
        expiryField.keyboardType = .numberPad
        configure(expiryError)
        configure(cvcField, placeholder: "123", label: "Security code")
        cvcField.keyboardType = .numberPad
        cvcField.isSecureTextEntry = true
        configure(cvcError)

        let expiryColumn = UIStackView(arrangedSubviews: [makeTitle("Expiry date"), expiryField, expiryError])
        let cvcColumn = UIStackView(arrangedSubviews: [makeTitle("Security code"), cvcField, cvcError])
        for column in [expiryColumn, cvcColumn] {
            column.axis = .vertical
            column.spacing = 6
        }
        let cardColumns = UIStackView(arrangedSubviews: [expiryColumn, cvcColumn])
        cardColumns.axis = .horizontal
        cardColumns.alignment = .top
        cardColumns.distribution = .fillEqually
        cardColumns.spacing = 12
        formStack.addArrangedSubview(cardColumns)
        formStack.setCustomSpacing(28, after: cardColumns)

        payButton.setTitle("Pay \(total.asPrice)", for: .normal)
        payButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        payButton.setTitleColor(UIColor(named: "OnAccent"), for: .normal)
        payButton.backgroundColor = UIColor(named: "AccentColor")
        payButton.layer.cornerRadius = 8
        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
        payButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        formStack.addArrangedSubview(payButton)
        formStack.setCustomSpacing(12, after: payButton)

        let note = UILabel()
        note.text = "This is a demo. No payment is taken."
        note.font = .systemFont(ofSize: 12)
        note.textColor = .secondaryLabel
        note.textAlignment = .center
        note.numberOfLines = 0
        formStack.addArrangedSubview(note)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }

    private func makeSummary() -> UIView {
        let totalColumn = UIStackView(arrangedSubviews: [
            makeTitle("Order total"),
            makeValue(total.asPrice)
        ])
        let pickupColumn = UIStackView(arrangedSubviews: [
            makeTitle("Pick up from"),
            makeValue("14 Mill Lane")
        ])
        for column in [totalColumn, pickupColumn] {
            column.axis = .vertical
            column.spacing = 4
        }

        let columns = UIStackView(arrangedSubviews: [totalColumn, pickupColumn])
        columns.axis = .horizontal
        columns.distribution = .fillEqually
        columns.spacing = 12
        columns.isLayoutMarginsRelativeArrangement = true
        columns.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let background = UIView()
        background.backgroundColor = .secondarySystemGroupedBackground
        background.layer.cornerRadius = 16
        background.translatesAutoresizingMaskIntoConstraints = false
        columns.insertSubview(background, at: 0)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: columns.topAnchor),
            background.bottomAnchor.constraint(equalTo: columns.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: columns.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: columns.trailingAnchor)
        ])
        return columns
    }

    private func makeTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    private func makeValue(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }

    private func configure(_ field: UITextField, placeholder: String, label: String) {
        field.placeholder = placeholder
        field.accessibilityLabel = label
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.borderStyle = .none
        field.backgroundColor = .secondarySystemGroupedBackground
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray2.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        field.leftViewMode = .always
        field.autocorrectionType = .no
        field.delegate = self
        field.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
    }

    private func configure(_ errorLabel: UILabel) {
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = UIColor(named: "ErrorText")
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
    }

    private var isFormComplete: Bool {
        [nameField, cardField, expiryField, cvcField].allSatisfy { !($0.text ?? "").isEmpty }
    }

    private func updatePayButton() {
        payButton.alpha = isFormComplete ? 1 : 0.4
    }

    private func clearCardDetails() {
        cardField.text = ""
        expiryField.text = ""
        cvcField.text = ""
        updatePayButton()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func textChanged(_ field: UITextField) {
        if field === cardField {
            let digits = String((field.text ?? "").filter(\.isNumber).prefix(16))
            var groups: [String] = []
            var rest = Substring(digits)
            while !rest.isEmpty {
                groups.append(String(rest.prefix(4)))
                rest = rest.dropFirst(4)
            }
            field.text = groups.joined(separator: " ")
        } else if field === expiryField {
            let digits = String((field.text ?? "").filter(\.isNumber).prefix(4))
            field.text = digits.count > 2 ? "\(digits.prefix(2))/\(digits.dropFirst(2))" : digits
        } else if field === cvcField {
            field.text = String((field.text ?? "").filter(\.isNumber).prefix(3))
        }
        updatePayButton()
    }

    @objc private func payTapped() {
        guard isFormComplete else { return }
        view.endEditing(true)

        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespaces)
        let cardDigits = (cardField.text ?? "").filter(\.isNumber)
        let expiry = expiryField.text ?? ""
        let cvc = cvcField.text ?? ""

        let nameMessage = name.count >= 2 ? nil : "Enter the name we should call out."
        let cardMessage = cardDigits.count == 16 ? nil : "Enter the 16 digits on the front of your card."
        let expiryMessage = isValidExpiry(expiry) ? nil : "Use the format MM/YY."
        let cvcMessage = cvc.count == 3 ? nil : "Enter the 3 digits on the back."

        show(nameMessage, in: nameError, for: nameField)
        show(cardMessage, in: cardError, for: cardField)
        show(expiryMessage, in: expiryError, for: expiryField)
        show(cvcMessage, in: cvcError, for: cvcField)

        guard nameMessage == nil, cardMessage == nil, expiryMessage == nil, cvcMessage == nil else {
            return
        }

        clearTask?.cancel()
        onComplete(name, pickupControl.selectedSlot)
    }

    private func show(_ message: String?, in label: UILabel, for field: UITextField) {
        label.text = message
        label.isHidden = message == nil
        field.layer.borderColor = (message == nil ? UIColor.systemGray2 : UIColor(named: "ErrorText") ?? .systemRed).cgColor
        field.layer.borderWidth = message == nil ? 1 : 2
    }

    private func isValidExpiry(_ text: String) -> Bool {
        let parts = text.split(separator: "/")
        guard parts.count == 2, parts[1].count == 2, let month = Int(parts[0]), Int(parts[1]) != nil else {
            return false
        }
        return (1...12).contains(month)
    }
}

extension CheckoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameField {
            cardField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
