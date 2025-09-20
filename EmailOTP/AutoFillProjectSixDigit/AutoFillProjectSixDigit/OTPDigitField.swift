import UIKit

final class OTPDigitField: UITextField {
    var onBackspace: ((OTPDigitField, Bool) -> Void)?
    
    override var isFirstResponder: Bool {
        let wasFirst = super.isFirstResponder
        return wasFirst
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
        backgroundColor = .secondarySystemBackground
        textAlignment = .center
        font = .monospacedDigitSystemFont(ofSize: 24, weight: .medium)
        keyboardType = .numberPad
        textContentType = .oneTimeCode
    }
    
    override func deleteBackward() {
        let hadText = !(text?.isEmpty ?? true)
        super.deleteBackward()
        onBackspace?(self, hadText)
    }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        applyGlow(true)
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        applyGlow(false)
        return result
    }

    private func applyGlow(_ on: Bool) {
        if on {
            layer.borderColor = viewTintColor().cgColor
            layer.shadowColor = viewTintColor().cgColor
            layer.shadowOpacity = 0.35
            layer.shadowRadius = 6
            layer.shadowOffset = .zero
        } else {
            layer.borderColor = UIColor.separator.cgColor
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
        }
    }

    private func viewTintColor() -> UIColor {
        window?.tintColor ?? tintColor
    }
}
