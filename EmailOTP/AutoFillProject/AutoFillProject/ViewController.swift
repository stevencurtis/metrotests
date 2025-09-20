import UIKit

final class ViewController: UIViewController {
    private let codeField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter code"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Code entered:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(codeField)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            codeField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            codeField.widthAnchor.constraint(equalToConstant: 200),

            label.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        codeField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
    }

    @objc private func codeChanged() {
        label.text = "Code entered: \(codeField.text ?? "")"
    }
}
