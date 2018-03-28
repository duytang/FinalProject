//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/26/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = HomeViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        tableView.registerCell(aClass: ContentTableViewCell.self)
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        viewModel.getCategories()
    }

    // MARK: - Actions
    @IBAction private func selectCategoryButtonTapped(sende: UIButton) {

    }

    @IBAction private func searchButtonTapped(sender: UIButton) {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: false)
    }
}

// MARK: - Extension
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueCell(aClass: ContentTableViewCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
