//
//  CategoryTableViewCell.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class CategoryTableViewCell: TableViewCell {
    // MARK: - Outlet
    @IBOutlet private weak var nameLabel: UILabel!

    var viewModel = CategoryTableCellViewModel() {
        didSet {
            nameLabel.text = viewModel.nameCategory
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
