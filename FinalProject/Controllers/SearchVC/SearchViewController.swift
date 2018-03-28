//
//  SearchViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class SearchViewController: ViewController {
    // MARK: - Outles

    // MARK: - Properties

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
    }
}

// MARK: - Extensions
