//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/26/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController, AlertViewController, LoadingViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var categoryNameLabel: UILabel!

    // MARK: - Properties
    var viewModel = HomeViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        tableView.rowHeight = 240
        tableView.registerCell(aClass: ContentTableViewCell.self)
        if !viewModel.categories.isEmpty, let firstCategory = viewModel.categories.first {
            categoryNameLabel.text = firstCategory.name
        }
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        loadData()
    }

    private func loadData() {
        showLoading()
        viewModel.getCategories { [weak self](result) in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showAlert(title: "Note", message: error.message)
            }
        }
    }

    private func loadVideo() {
        showLoading()
        viewModel.getVideos { [weak self](result) in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showAlert(title: "Note", message: error.message)
            }
        }
    }

    // MARK: - Actions
    @IBAction private func selectCategoryButtonTapped(sende: UIButton) {
        let categoryVC = CategoryViewController()
        categoryVC.viewModel = CategoryViewModel(datasource: viewModel.categories)
        guard let window = AppDelegate.shared.window else { return }
        categoryVC.showPopup(inView: window, controller: self, delegate: self)
    }

    @IBAction private func searchButtonTapped(sender: UIButton) {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueCell(aClass: ContentTableViewCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
}

// MARK: - CategoryViewControllerDelegate
extension HomeViewController: CategoryViewControllerDelegate {
    func listView(controller: CategoryViewController, didSelectIndex index: Int) {
        categoryNameLabel.text = viewModel.categories[index].name
        viewModel.title = viewModel.categories[index].name
        viewModel.idCategory = viewModel.categories[index].id
        viewModel.nextPage = ""
        viewModel.videos = []
        loadVideo()
    }
}
