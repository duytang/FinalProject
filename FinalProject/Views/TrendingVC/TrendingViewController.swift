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
        getListTrendingVideo()
    }

    private func getListTrendingVideo(isShowLoading: Bool = true) {
        if isShowLoading {
            showLoading()
        }
        viewModel.getListTrending { [weak self](result) in
            guard let this = self else { return }
            this.hideLoading()
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showErrorAlert(message: error.message ?? "")
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let scrollMaxSize = scrollView.contentSize.height - scrollView.frame.height
        if scrollMaxSize - contentOffset < 50 && viewModel.isLoadMore {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            getListTrendingVideo(isShowLoading: false)
        }
    }
}

extension TrendingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.viewModel = DetailVideoViewModel(video: viewModel.videos[indexPath.row])
        navigationController?.present(detailVideoVC, animated: true, completion: nil)
    }
}
