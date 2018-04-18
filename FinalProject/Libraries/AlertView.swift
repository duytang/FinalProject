//
//  AlertView.swift
//  Coffee Bussiness
//
//  Created by Kieu Nhi on 6/13/17.
//  Copyright © 2017 Coffee. All rights reserved.
//

import UIKit

enum AlertType {
    case success
    case warning
    case error

    var icon: UIImage {
        switch self {
        case .success:
            return #imageLiteral(resourceName: "icon_success")
        case .warning:
            return #imageLiteral(resourceName: "icon_warning")
        case .error:
            return #imageLiteral(resourceName: "icon_error")

        }
    }
}

class AlertView: UIView {

    static let height: CGFloat = 60
    lazy private var messageLabel: UILabel = {
        let width = kScreen.bounds.width - 40 - 10
        let label = UILabel(frame: CGRect(x: 40, y: 0, width: width, height: AlertView.height))
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        label.font = Font.helveticaNeue.normal(ofSize: 12)
        return label
    }()

    lazy private var iconImageView: UIImageView! = {
        let imageView = UIImageView(frame: CGRect(x: 13, y: 0, width: 20, height: 20))
        imageView.center.y = AlertView.height / 2
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var message = "" {
        didSet {
            messageLabel.text = message
        }
    }
    var type: AlertType = .success {
        didSet {
            iconImageView.image = type.icon
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(iconImageView)
        addSubview(messageLabel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(messageLabel)

    }

    class func showAlert(_ type: AlertType, message: String, inView view: UIView) {
        view.subviews.forEach {
            if $0.isKind(of: AlertView.self) {
                $0.removeFromSuperview()
            }
        }

        let alertView = AlertView(frame: CGRect(x: 0,
                                                y: -AlertView.height,
                                                width: kScreen.bounds.width,
                                                height: AlertView.height))

        alertView.backgroundColor = UIColor.white
        let startPoint = CGPoint(x: 0, y: -AlertView.height)
        let endPoint = CGPoint.zero
        alertView.message = message
        alertView.type = type
        alertView.shadow(offset: CGSize(width: 0, height: 2), color: .black, radius: 2, opacity: 0.35, cornerRadius: 0)
        view.addSubview(alertView)

        UIView.animate(withDuration: 0.3, animations: {
            alertView.frame.origin = endPoint
        }, completion: { (_) in
            DispatchQueue.after(time: 2, {
                UIView.animate(withDuration: 0.3, animations: {
                    alertView.frame.origin = startPoint
                }, completion: { (_) in
                    alertView.removeFromSuperview()
                })
            })
        })
    }

}
