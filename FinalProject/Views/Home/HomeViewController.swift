//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/26/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import SVPullToRefresh

final class HomeViewController: ViewController, AlertViewController, LoadingViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var categoryNameLabel: UILabel!

    // MARK: - Properties
    var viewModel = HomeViewModel()
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
        tableView.addPullToRefresh {
            self.viewModel.nextPage = ""
            self.tableView.pullToRefreshView.stopAnimating()
            self.loadVideo()
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
            switch result {
            case .success:
                this.categoryNameLabel.text = this.viewModel.title
                this.loadVideo()
            case .failure(let error):
                this.hideLoading()
                this.showAlert(title: "Note", message: error.message)
            }
        }
    }

    private func loadVideo() {
        viewModel.getVideos { [weak self](result) in
            guard let this = self else { return }
            this.hideLoading()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && viewModel.isLoadMore {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            loadVideo()
        }
    }
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.viewModel = DetailVideoViewModel(video: viewModel.videos[indexPath.row])
        dragVideo.prensentDetailVideoVC(video: viewModel.videos[indexPath.row])
    }
}

// MARK: - CategoryViewControllerDelegate
extension HomeViewController: CategoryViewControllerDelegate {
    func listView(controller: CategoryViewController, didSelectIndex index: Int) {
        categoryNameLabel.text = viewModel.categories[index].name
        viewModel.title = viewModel.categories[index].name
        viewModel.idCategory = viewModel.categories[index].id
        viewModel.nextPage = ""
        loadVideo()
    }
}
