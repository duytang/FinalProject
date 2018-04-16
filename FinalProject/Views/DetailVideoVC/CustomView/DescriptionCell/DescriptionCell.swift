//
//  DescriptionCell.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/7/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

final class DescriptionCell: TableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var descriptionLabel: FVReadMoreLabel!

    // MARK: - Property
    var viewModel = DescriptionCellViewModel() {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.collapsed = true
        descriptionLabel.text = nil
    }

    // MARK: - Private func
    private func updateUI() {
        descriptionLabel.text = viewModel.description
    }
}
