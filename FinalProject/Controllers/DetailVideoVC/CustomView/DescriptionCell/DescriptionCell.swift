//
//  DescriptionCell.swift
//  FinalProject
//
//  Created by Duy Tang on 4/7/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class DescriptionCell: TableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Property
    var viewModel = DescriptionCellViewModel() {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Private func
    private func updateUI() {
        descriptionLabel.text = viewModel.description
    }
}
