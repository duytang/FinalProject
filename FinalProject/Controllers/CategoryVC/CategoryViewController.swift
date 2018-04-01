//
//  CategoryViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 4/1/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

protocol CategoryViewControllerDelegate: class {
    func listView(controller: CategoryViewController, didSelectIndex index: Int)
}

final class CategoryViewController: ViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = CategoryViewModel()
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setup() {
        super.setup()
        modalPresentationStyle = .overCurrentContext
    }

    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        contentView.corner(5)
        tableView.rowHeight = 40
        tableView.registerCell(aClass: TitleCell.self)
        view.backgroundColor = Color.popupBG
        showAnimation()
    }

    func showPopup(inView view: UIView, controller: UIViewController, delegate: CategoryViewControllerDelegate) {
        self.view.frame = kScreen.bounds
        view.addSubview(self.view)
        self.delegate = delegate
        controller.addChildViewController(self)
    }

    func showAnimation() {
        contentView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        contentView.alpha = 0

        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.contentView.alpha = 1
        })
    }

    func hideAnimation() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        }, completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideAnimation()
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(aClass: TitleCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: -
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.listView(controller: self, didSelectIndex: indexPath.row)
        hideAnimation()
    }
}
