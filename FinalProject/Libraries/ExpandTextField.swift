//
//  ExpandTextField.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/12/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import UIKit

@IBDesignable
class ExpandTextField: UITextField {

    var label: UILabel!
    var securityButton: UIButton!

    @IBInspectable var isSecurity: Bool = false {
        didSet {
            if isSecurity {
                rightView = securityButton
                rightViewMode = .whileEditing
                changeTitleSecurity()
            } else {
                rightView = nil
            }
        }
    }

    override var placeholder: String? {
        didSet {
            label.text = placeholder
            changeColorPlaceholder()
        }
    }

    override var font: UIFont? {
        didSet {
            label.font = font ?? Font.helveticaNeue.normal(ofSize: 14)
        }
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        label = UILabel(frame: bounds)
        label.textColor = UIColor.lightGray
        label.text = placeholder
        label.font = font ?? Font.helveticaNeue.normal(ofSize: 14)
        changeColorPlaceholder()
        insertSubview(label, at: 0)

        securityButton = UIButton(type: .custom)
        securityButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        securityButton.titleLabel?.font = Font.helveticaNeue.normal(ofSize: 14)
        securityButton.setTitleColor(UIColor.blue, for: .normal)
        if isSecurity {
            rightView = securityButton
            rightViewMode = .whileEditing
            changeTitleSecurity()
        }

        securityButton.addTarget(self, action: #selector(didSelectSecurity(sender:)), for: .touchUpInside)
        //Actions input text
        addTarget(self, action: #selector(beginEditText(textField:)), for: .editingDidBegin)
        addTarget(self, action: #selector(endEditText(textField:)), for: .editingDidEnd)
        addTarget(self, action: #selector(editingChangedValue(textField:)), for: .editingChanged)
    }

    private func changeColorPlaceholder() {
        let attributed = NSMutableAttributedString(string: placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clear])
        attributedPlaceholder = attributed
    }

    private func changeTitleSecurity() {
        let text = isSecureTextEntry ? "Show" : "Hide"
        securityButton.setTitle(text, for: .normal)
    }

    // MARK: - Actions
    @objc private func editingChangedValue(textField: UITextField) {
        let value = textField.text ?? ""
        showAnimation(isExpand: !value.isEmpty)
    }

    @objc private func beginEditText(textField: UITextField) {}

    @objc private func endEditText(textField: UITextField) {}

    @objc private func didSelectSecurity(sender: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        changeTitleSecurity()
    }

    private func showAnimation(isExpand: Bool) {
        let viewTransform = isExpand ?
            CGAffineTransform(scaleX: 0.7, y: 0.7) :
            CGAffineTransform(scaleX: 1, y: 1)

        let layerTransform = isExpand ?
            CATransform3DMakeTranslation(0, 8, 0) :
            CATransform3DMakeTranslation(0, 0, 0)

        let origin = isExpand ? CGPoint(x: 0, y: -10) : .zero
        UIView.animate(withDuration: 0.25) {
            self.label.transform = viewTransform
            self.label.frame.origin = origin
            self.layer.transform = layerTransform
        }
    }
}
