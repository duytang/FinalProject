//
//  FavoriteListViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import SwifterSwift

final class FavoriteListViewController: ViewController, AlertViewController {
    // MARK: - Outlets
     @IBOutlet private weak var tableView: UITableView!

    // MARK: - Property
    var viewModel = FavoriteListViewModel()
    var dragVideo: DraggalbeVideoManager!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = tabBarController {
            dragVideo = DraggalbeVideoManager(rootViewController: tabBarController)
            dragVideo.draggbleProgress()
            dragVideo.addActionToView()
        }
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        if let favorite = viewModel.favorite {
            title = favorite.name
        }
        tableView.registerCell(aClass: FavoriteListCell.self)
        tableView.rowHeight = 72
        addRightBarButton(image: #imageLiteral(resourceName: "ic_delete"), action: #selector(deleteAll))
        kNotification.addObserver(self,
                                  selector: #selector(loadData),
                                  name: NSNotification.Name(NoticationName.reloadFavoriteList),
                                  object: nil)
    }

    // MARK: - Private func
    @objc private func deleteAll() {
        showAlertView(title: "Note", message: "Do you wanna delete all videos?", cancelButton: "Cancel", otherButtons: ["OK"], type: .alert, cancelAction: nil) { (_) in
            guard let list = self.viewModel.getFavoriteList() else { return }
            RealmManager.shared.write(action: { (_) in
                list.listVideo.removeAll()
                self.tableView.reloadData()
                self.showAlertView(title: "Note", message: "Do you wanna delete this favorite list?", cancelButton: "Cancel", otherButtons: ["OK"], type: .alert, cancelAction: nil, otherAction: { (_) in
                    RealmManager.shared.delete(object: list)
                    self.back()
                })
            })
        }
    }
    @objc private func loadData() {
        guard let favoriteList = viewModel.getFavoriteList() else { return }
        viewModel.videos = Array(favoriteList.listVideo)
        tableView.reloadData()
    }
}
// MARK: - UITableViewDataSource
extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(aClass: FavoriteListCell.self)
        cell.viewModel = FavoriteListCellViewModel(video: viewModel.videos[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.viewModel = DetailVideoViewModel(video: viewModel.videos[indexPath.row])
        dragVideo.prensentDetailVideoVC(video: viewModel.videos[indexPath.row])
    }
}
