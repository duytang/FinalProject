//
//  AddToFavoriteListViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 4/10/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

protocol AddToFavoriteListViewControllerDelegate: class {
    func favoriteList(controller: AddToFavoriteListViewController, nameList: String)
}

class AddToFavoriteListViewController: ViewController, AlertViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var contentView: UIView!

    // MARK: - Properties
    var viewModel = AddToFavoriteListViewModel()
    weak var delegate: AddToFavoriteListViewControllerDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup
    override func setup() {
        super.setup()
        modalPresentationStyle = .overCurrentContext
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        viewModel.getData()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        contentView.corner(5)
        tableView.rowHeight = 40
        tableView.registerCell(aClass: TitleCell.self)
        view.backgroundColor = Color.popupBG
        showAnimation()
    }

    // MARK: - Action

    @IBAction func createNewFavoriteListButtonTapped(sender: UIButton) {
        showInputDialog(title: "Youtube", subtitle: "Enter name", actionTitle: "OK", cancelTitle: "Cancel") { (newList) in
            guard let newList = newList else { return }
            if !newList.isEmpty {
                let favarite = FavoriteList()
                favarite.id = self.viewModel.getId()
                favarite.name = newList
                RealmManager.shared.add(object: favarite)
                self.viewModel.getData()
                self.tableView.reloadData()
            }
        }
    }

    func showPopup(inView view: UIView, controller: UIViewController,
                   delegate: AddToFavoriteListViewControllerDelegate) {
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

extension AddToFavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(aClass: TitleCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension AddToFavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let video = viewModel.video else { return }
        viewModel.getData()
        if !viewModel.checkExist(id: video.idVideo,
                                videos: Array(viewModel.favoriteList[indexPath.row].listVideo)) {
            RealmManager.shared.write { (_) in
                self.viewModel.favoriteList[indexPath.row].listVideo.append(video)
                self.delegate?.favoriteList(controller: self,
                                            nameList: self.viewModel.favoriteList[indexPath.row].name)
            }
        } else {
            showAlert(title: "Youtube", message: "Video has been exist on the list")
        }
        hideAnimation()
    }
}
