//
//  CategoryCollectionCell.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class CategoryCollectionCell: UICollectionViewCell {
    // MARK: - Outlet
    @IBOutlet private weak var categoryLabel: UILabel!

    var viewModel = CategoryCollectionViewModel() {
        didSet {
            categoryLabel.text = viewModel.nameCategory
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
