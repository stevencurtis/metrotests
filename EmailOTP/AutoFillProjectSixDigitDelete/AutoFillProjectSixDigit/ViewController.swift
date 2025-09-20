import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {
    private let digitsCount = 6
    private var fields: [OTPDigitField] = []
    private let stackView = UIStackView()
    private let codeLabel: UILabel = {
        let l = UILabel()
        l.text = "Code entered:"
        l.textAlignment = .center
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupStack()
        setupFields()
        layoutUI()
        DispatchQueue.main.async { [weak self] in
            _ = self?.fields.first?.becomeFirstResponder()
        }
    }

    // MARK: - UI

    private func setupStack() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
    }

    private func setupFields() {
        for _ in 0..<digitsCount {
            let field = OTPDigitField()
            field.delegate = self
            field.translatesAutoresizingMaskIntoConstraints = false
            field.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)

            field.onBackspace = { [weak self] field, hadText in
                guard let self = self else { return }
                self.moveFocusBackward(from: field)
                self.updateLabel()
            }
            
            NSLayoutConstraint.activate([
                field.heightAnchor.constraint(equalToConstant: 50),
                field.widthAnchor.constraint(equalToConstant: 40)
            ])
            fields.append(field)
            stackView.addArrangedSubview(field)
        }
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStackTap))
        stackView.addGestureRecognizer(tap)
    }

    private func layoutUI() {
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(codeLabel)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9),

            codeLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            codeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Helpers

    private func currentCode() -> String {
        fields.compactMap { $0.text }.joined()
    }

    private func setCode(_ code: String) {
        let trimmed = code.filter(\.isNumber).prefix(digitsCount)
        for (i, field) in fields.enumerated() {
            let char = trimmed.dropFirst(i).first
            field.text = char.map(String.init)
        }
        updateLabel()
        if trimmed.count >= digitsCount {
            _ = fields.last?.resignFirstResponder()
        } else {
            nextEmptyField()?.becomeFirstResponder()
        }
    }

    private func nextEmptyField() -> UITextField? {
        fields.first { ($0.text ?? "").isEmpty }
    }

    private func moveFocusForward(from field: UITextField) {
        guard let idx = fields.firstIndex(of: field as! OTPDigitField) else { return }
        let nextIdx = idx + 1
        if nextIdx < fields.count {
            _ = fields[nextIdx].becomeFirstResponder()
        } else {
            field.resignFirstResponder()
        }
    }

    private func moveFocusBackward(from field: UITextField) {
        guard let idx = fields.firstIndex(of: field as! OTPDigitField) else { return }
        let prevIdx = idx - 1
        if prevIdx >= 0 {
            _ = fields[prevIdx].becomeFirstResponder()
            // fields[prevIdx].text = ""
        }
    }

    private func updateLabel() {
        codeLabel.text = "Code entered: \(currentCode())"
    }

    // MARK: - Actions

    @objc private func handleStackTap() {
        (nextEmptyField() ?? fields.last)?.becomeFirstResponder()
    }

    @objc private func editingChanged(_ sender: UITextField) {
        // If user pasted a whole code into one box, distribute it.
        if let text = sender.text, text.count > 1 {
            setCode(text)
        } else {
            updateLabel()
        }

        // Auto-advance when a single digit is entered
        if let text = sender.text, text.count == 1 {
            moveFocusForward(from: sender)
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let isPastingMulti = string.count > 1

        // Handle paste of full code (e.g. from AutoFill)
        if isPastingMulti {
            DispatchQueue.main.async { [weak self] in
                self?.setCode(string)
            }
            return false
        }

        // Handle backspace – just allow it, OTPDigitField.deleteBackward will do the work
        if string.isEmpty {
            return true
        }

        // Handle single digit entry
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }

        textField.text = string
        updateLabel()
        moveFocusForward(from: textField)
        return false
    }
}
