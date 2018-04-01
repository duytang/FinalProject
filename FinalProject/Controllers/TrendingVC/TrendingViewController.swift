//
//  TrendingViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

class TrendingViewController: ViewController, AlertViewController, LoadingViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = TrendingViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        title = Title.trending
        tableView.rowHeight = 240
        tableView.registerCell(aClass: ContentTableViewCell.self)
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        viewModel.getListTrending { (result) in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(message: error.message ?? "")
            }
        }
    }
}

// MARK: - Extension
extension TrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(aClass: ContentTableViewCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension TrendingViewController: UITableViewDelegate {

}
