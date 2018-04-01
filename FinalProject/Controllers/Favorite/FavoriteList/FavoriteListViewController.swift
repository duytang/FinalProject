//
//  FavoriteListViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/30/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit
import SwifterSwift

final class FavoriteListViewController: ViewController {
    // MARK: - Outlets
     @IBOutlet private weak var tableView: UITableView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        tableView.registerCell(aClass: FavoriteListCell.self)
        tableView.rowHeight = 72
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
    }
}
// MARK: - Extensions

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(aClass: FavoriteListCell.self)
        return cell
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
