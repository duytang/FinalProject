//
//  ExpandTextField.swift
//  Coffee Bussiness
//
//  Created by Kieu Nhi on 6/12/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import UIKit

@IBDesignable
class LinearTextField: UITextField {

    var lineLayer: CALayer!

    @IBInspectable var normalColor: UIColor = UIColor.white
    @IBInspectable var editingColor: UIColor = UIColor.mainColor
    @IBInspectable var lineHeight: CGFloat = 1

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        calculateLinearLayerFrame()
    }

    func setup() {
        lineLayer = CALayer()
        lineLayer.backgroundColor = normalColor.cgColor
        calculateLinearLayerFrame()
        layer.addSublayer(lineLayer)
        //Actions input text
        addTarget(self, action: #selector(beginEditText(textField:)), for: .editingDidBegin)
        addTarget(self, action: #selector(endEditText(textField:)), for: .editingDidEnd)
        addTarget(self, action: #selector(editingChangedValue(textField:)), for: .editingChanged)
    }

    func calculateLinearLayerFrame() {
        let y = frame.height - lineHeight
        lineLayer.frame = CGRect(x: 0, y: y, width: frame.width, height: lineHeight)
    }

    // MARK: - Actions
    @objc private func editingChangedValue(textField: UITextField) {
    }

    @objc private func beginEditText(textField: UITextField) {
        lineLayer.backgroundColor = editingColor.cgColor
    }

    @objc private func endEditText(textField: UITextField) {
        lineLayer.backgroundColor = normalColor.cgColor
    }

    private func showAnimation(isExpand: Bool) {

    }
}
