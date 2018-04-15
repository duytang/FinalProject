//
//  HistoryViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

class HistoryViewController: ViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        title = Title.history
        addRightBarButton(image: #imageLiteral(resourceName: "ic_delete"), action: #selector(deleteAll))
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
    }

    // MARK: - Private func
    @objc private func deleteAll() {

    }
}

// MARK: - Extension