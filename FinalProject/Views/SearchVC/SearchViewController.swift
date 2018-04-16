//
//  SearchViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

final class SearchViewController: ViewController {
    // MARK: - Outles
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var keywordTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = SearchViewModel()
    var keyword = ""

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        searchBar.backgroundImage = UIImage()
        keywordTableView.registerCell(aClass: SearchTableViewCell.self)
        searchBar.becomeFirstResponder()
        if let textField = searchBar.value(forKey: "_searchField") as? UITextField {
            textField.clearButtonMode = .never
        }
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        loadListKey(keyword: keyword)
    }

    // MARK: - Action
    @IBAction private func deleteButtonTapped(sender: UIButton) {
        keyword = ""
        loadListKey(keyword: keyword)
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
        if tableView.tag == 0 {
            return viewModel.suggestKeys.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueCell(aClass: SearchTableViewCell.self)
            cell.viewModel = SearchTableCellViewModel(title: viewModel.suggestKeys[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueCell(aClass: RelateVideoCell.self)
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleteButton.isHidden = searchText.isEmpty ? true : false
        keyword = searchText
        loadListKey(keyword: keyword)
    }
}
