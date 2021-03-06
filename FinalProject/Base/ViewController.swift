//
//  BaseViewController.swift
//  ATMCard
//
//  Created by Kieu Nhi on 5/12/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD

protocol AlertViewController { }
protocol LoadingViewController { }

extension AlertViewController where Self: UIViewController {
    func showAlertView(title: String?, message: String?, cancelButton: String?,
                       otherButtons: [String]? = nil, type: UIAlertControllerStyle = .alert,
                       cancelAction: (() -> Void)? = nil, otherAction: ((Int) -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelButton = cancelButton {
            let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: { (_) in
                cancelAction?()
            })
            alertViewController.addAction(cancelAction)
        }

        if let otherButtons = otherButtons {
            for (index, otherButton) in otherButtons.enumerated() {
                let otherAction = UIAlertAction(title: otherButton,
                                                style: .default, handler: { (_) in
                                                    otherAction?(index)
                })
                alertViewController.addAction(otherAction)
            }
        }

        DispatchQueue.main.async {
            self.present(alertViewController, animated: true, completion: nil)
        }
    }

    func showInputDialog(title: String? = nil,
                         subtitle: String? = nil,
                         actionTitle: String? = "Add",
                         cancelTitle: String? = "Cancel",
                         inputPlaceholder: String? = nil,
                         inputKeyboardType: UIKeyboardType = .default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (_) in
            guard let textField = alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }

    }

    func showErrorAlert(message: String?) {
        showAlertView(title: "Error", message: message, cancelButton: "OK")
    }

}

extension LoadingViewController where Self: UIViewController {
    func showLoading() {
        let hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub.mode = MBProgressHUDMode.indeterminate
    }

    func hideLoading() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.view.subviews.forEach({ (subView) in
                    if subView.isKind(of: MBProgressHUD.self) {
                        subView.removeFromSuperview()
                    }
                })
            }
        }
    }
}

class ViewController: UIViewController {

    var isLeftBarButtonHidden = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() { }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupUI() { }

    func setupData() { }

    func setUpNavigation() {
        if !isLeftBarButtonHidden {
            if let navigationController = navigationController {
                if let first = navigationController.viewControllers.first {
                    if first.className == self.className {
                        addCloseButton()
                    } else {
                        addBackButton()
                    }
                }
            }
        }

    }

    func addLeftBarButton(image: UIImage, action: Selector) {
        let leftButton = UIBarButtonItem(image: image, style: .done, target: self, action: action)
        navigationItem.leftBarButtonItem = leftButton
    }

    func addLeftBarButton(title: String, action: Selector) {
        let leftButton = UIBarButtonItem(title: title, style: .done, target: self, action: action)
        navigationItem.leftBarButtonItem = leftButton
    }

    func addRightBarButton(image: UIImage, action: Selector) {
        let rightButton = UIBarButtonItem(image: image, style: .done, target: self, action: action)
        navigationItem.rightBarButtonItem = rightButton
    }

    func addRightBarButton(title: String, action: Selector) {
        let rightButton = UIBarButtonItem(title: title, style: .done, target: self, action: action)
        navigationItem.rightBarButtonItem = rightButton
    }

    func addCloseButton() {
        let closeBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_close"), style: .done, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeBarButton
    }

    func addBackButton() {
        let backBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back"), style: .done, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBarButton

    }

    @IBAction func back() {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func close() {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
