//
//  SearchViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import SwifterSwift

final class SearchViewController: ViewController {
    // MARK: - Outles
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var keywordTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = SearchViewModel()
    var keyword = ""
    var dragVideo: DraggalbeVideoManager!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
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
        searchBar.backgroundImage = UIImage()
        keywordTableView.registerCell(aClass: SearchTableViewCell.self)
        tableView.registerCell(aClass: RelateVideoCell.self)
        searchBar.becomeFirstResponder()
        if let textField = searchBar.value(forKey: "_searchField") as? UITextField {
            textField.clearButtonMode = .never
        }
        keywordTableView.rowHeight = 40.scaling
        tableView.rowHeight = 90.scaling
        keywordTableView.removeHeaderTableView()
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        viewModel.getData()
    }

    // MARK: - Action
    @IBAction private func deleteButtonTapped(sender: UIButton) {
        keyword = ""
        searchBar.clear()
        viewModel.getData()
        keywordTableView.isHidden = false
        keywordTableView.reloadData()
    }

    // MARK: - Private func
    private func loadListKey(keyword: String) {
        viewModel.searchVideoName(keyword: keyword) { (_) in
            self.keywordTableView.reloadData()
        }
    }
}

// MARK: - Extensions

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == keywordTableView {
            return viewModel.suggestKeys.count
        } else {
            return viewModel.videos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == keywordTableView {
            let cell = tableView.dequeueCell(aClass: SearchTableViewCell.self)
            cell.viewModel = SearchTableCellViewModel(title: viewModel.suggestKeys[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueCell(aClass: RelateVideoCell.self)
            cell.viewModel = RelateVideoCellModel(video: viewModel.videos[indexPath.row])
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == keywordTableView {
            let keyword = viewModel.suggestKeys[indexPath.row]
            let time = Helper.getCurrentTime()
            let searchObj = SearchHistory(name: keyword,
                                          time: time.day + "-" + time.time)
            RealmManager.shared.add(object: searchObj)
            viewModel.searchVideo(from: keyword,
                                  nextPage: viewModel.nextPage, completion: { (data) in
                switch data {
                case .success:
                    self.tableView.reloadData()
                    self.keywordTableView.isHidden = true
                case .failure(let error):
                    self.showAlert(title: "Youtube", message: error.message)
                }
            })
        } else {
            let detailVideoVC = DetailVideoViewController()
            detailVideoVC.viewModel = DetailVideoViewModel(video: viewModel.videos[indexPath.row])
            dragVideo.prensentDetailVideoVC(video: viewModel.videos[indexPath.row])
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleteButton.isHidden = searchText.isEmpty ? true : false
        if searchText.isEmpty {
            viewModel.getData()
            keywordTableView.isHidden = false
            keywordTableView.reloadData()
        } else {
            keyword = searchText
            keywordTableView.isHidden = false
            loadListKey(keyword: keyword)
        }
    }
}
