//
//  SearchTextField.swift
//  Coffee Bussiness
//
//  Created by framgia on 6/15/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    var imageView: UIImageView! = nil
    var label: UILabel!

    private var widthImageView:CGFloat = 20

    private var halfWidthImageView:CGFloat {
        return self.widthImageView / 2
    }

    private var paddingLeft: CGFloat {
        return self.widthImageView + 8
    }


    override var placeholder: String? {
        didSet {
            label.text = placeholder
            label.frame.size = label.sizeToFitCharacter(width: bounds.width)!
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

        imageView = UIImageView(image: UIImage(named: "icon_search"))
        imageView.frame = CGRect(x: 0, y: 0, width: widthImageView, height: widthImageView)
        insertSubview(imageView, at: 0)
        calculatePosition(isEditting: false)


        //Actions input text
        addTarget(self, action: #selector(beginEditText(textField:)), for: .editingDidBegin)
        addTarget(self, action: #selector(endEditText(textField:)), for: .editingDidEnd)
        addTarget(self, action: #selector(editingChangedValue(textField:)), for: .editingChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let value = text ?? ""
        calculatePosition(isEditting: isEditing || !value.isEmpty)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: paddingLeft, dy: 0)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: widthImageView + 8, dy: 0)
    }

    private func calculatePosition(isEditting: Bool) {
        UIView.animate(withDuration: 0.3) {
            isEditting ? self.animationWhenEditing() : self.animationNoEditting()
        }
    }

    private func animationWhenEditing() {
        if let size = label.sizeToFitCharacter(width: bounds.width) {
            let x = halfWidthImageView + 3
            let y = bounds.center.y
            imageView.center = CGPoint(x: x, y: y)
            label.frame.size = size
            label.frame.origin = CGPoint(x: paddingLeft, y: imageView.frame.y)
        } else {
            label.frame.size = CGSize.zero
            let x = halfWidthImageView
            let y = bounds.center.y
            imageView.center = CGPoint(x: x, y: y)
        }
    }

    private func animationNoEditting() {
        if let size = label.sizeToFitCharacter(width: bounds.width) {
            self.label.frame.size = size
            self.label.center = bounds.center
            let x = (label.center.x - label.frame.width / 2) - halfWidthImageView - 5
            let y = label.center.y
            self.imageView.center = CGPoint(x: x, y: y)
        } else {
            self.label.frame.size = CGSize.zero
            self.imageView.center = bounds.center
        }
    }

    private func checkHiddenForLabel() {
        let value = text ?? ""
        label.isHidden = !value.isEmpty
    }

    private func changeColorPlaceholder() {
        let attributed = NSMutableAttributedString(string: placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.clear])
        attributedPlaceholder = attributed
    }

    //MARK: - Actions
    @objc private func editingChangedValue(textField: UITextField) {

        checkHiddenForLabel()
    }

    @objc private func beginEditText(textField: UITextField) {
        calculatePosition(isEditting: true)
        checkHiddenForLabel()
    }

    @objc private func endEditText(textField: UITextField) {
        let value = textField.text ?? ""
        checkHiddenForLabel()
        calculatePosition(isEditting: !value.isEmpty)
    }

}
