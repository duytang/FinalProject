//
//  SearchTableViewCell.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

class SearchTableViewCell: TableViewCell {

    // MARK: - Outlet
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel = SearchTableCellViewModel() {
        didSet {
            nameLabel.text = viewModel.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
