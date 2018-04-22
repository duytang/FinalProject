//
//  HistoryViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/27/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

final class HistoryViewController: ViewController, AlertViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = HistoryViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        title = Title.history
        tableView.registerCell(aClass: FavoriteListCell.self)
        tableView.rowHeight = 72
        tableView.removeHeaderTableView()
        addRightBarButton(image: #imageLiteral(resourceName: "ic_delete"), action: #selector(deleteAll))
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        viewModel.getData()
    }

    // MARK: - Private func
    @objc private func deleteAll() {
        showAlertView(title: "Youtube",
                      message: "Do you want delete all histories", cancelButton: "Cancel",
                      otherButtons: ["OK"]) { (_) in
                        RealmManager.shared.clean(History.self)
                        self.viewModel.getData()
                        self.tableView.reloadData()
        }
    }
}

// MARK: - Extension
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(aClass: FavoriteListCell.self)
        guard let video = viewModel.histories[indexPath.row].video else {
            fatalError("Cannot load video")
        }
        cell.viewModel = FavoriteListCellViewModel(video: video)
        return cell
    }
}
