//
//  TitleCell.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/1/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

class TitleCell: TableViewCell {
    // MARK: - Outlet
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Property
    var viewModel = TitleViewModel() {
        didSet {
            titleLabel.text = viewModel.title
        }
    }
}
