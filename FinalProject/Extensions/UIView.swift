//
//  UIViewExtension.swift
//  ATMCard
//
//  Created by framgia on 5/11/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

enum GradientStyle {
    case leftToRight
    case topToBottom
}

extension UIView {

    var snapshotImage: UIImage {
        UIView.setAnimationsEnabled(false)
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIView.setAnimationsEnabled(true)
        if let image = image {
            return image
        } else {
            return UIImage()
        }
    }

    func shadow(offset: CGSize = CGSize(width: 0, height: -5), color: UIColor = UIColor.black, radius: CGFloat = 2, opacity: Float = 0.35, cornerRadius: CGFloat = 20) {
        let shadowLayer = layer
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.masksToBounds = false

        shadowLayer.shadowOffset = offset
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowLayer.bounds, cornerRadius: cornerRadius ).cgPath

        let bColor = backgroundColor?.cgColor
        shadowLayer.backgroundColor = bColor
    }

    func removeShadow() {
        let shadowLayer = self.layer
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowColor = UIColor.clear.cgColor
        shadowLayer.shadowRadius = 0
        shadowLayer.shadowOpacity = 0
        shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowLayer.bounds, cornerRadius: shadowLayer.cornerRadius).cgPath
    }

    func backgroundGradient(style: GradientStyle, colors: [UIColor]) {
        removeGradient()
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBackground"
        if style == .leftToRight {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.locations = [0.0, 1.0]
        }
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        })
        backgroundColor = UIColor.clear
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func removeGradient() {
        _ = layer.sublayers?.filter({ $0.name == "GradientBackground" }).map({ $0.removeFromSuperlayer() })
    }

    func corner(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    func border(borderWidth: CGFloat, color: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }

    class func loadXibView<T: UIView>(fromNib viewType: T.Type, owner: Any?) -> UIView {
        let nibName = String(describing: viewType)
        guard let view = UINib.nib(named: nibName).instantiate(withOwner: owner, options: nil)[0] as? UIView else {
            fatalError("Can not load nib name: \(viewType)")
        }
        return view
    }

    class func loadView<T: UIView>(fromNib viewType: T.Type) -> T {
        let nibName = String(describing: viewType)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? T else {
            fatalError("\(T.className) isn't exist")
        }
        return view
    }

    class func loadView() -> Self {
        let view = loadView(fromNib: self)
        return view
    }

    func findImageView() -> UIImageView? {
        let imageViews = subviews.filter { (subView) -> Bool in
            if subView is UIImageView {
                return true
            }
            return false
        }
        return !imageViews.isEmpty ? imageViews.first as? UIImageView : nil
    }

    func findLabel() -> UILabel? {
        let labels = subviews.filter { (subView) -> Bool in
            if subView is UILabel {
                return true
            }
            return false
        }
        return !labels.isEmpty ? labels.first as? UILabel : nil
    }
}
