//
//  RelateVideoCell.swift
//  FinalProject
//
//  Created by Duy Tang on 4/7/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

class RelateVideoCell: TableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var channelLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    // MARK: - Property
    var viewModel = RelateVideoCellModel() {
        didSet {
            updateUI()
        }
    }

    // MARK: - Private func
    private func updateUI() {
        videoImageView?.downloadImage(fromURL: viewModel.image, placeHolder: #imageLiteral(resourceName: "ic_chanel"))
        nameLabel.text = viewModel.name
        channelLabel.text = viewModel.channelTitle + "・" + viewModel.numberView.convertNumberView()
        durationLabel.text = viewModel.duration.convertDuration()
    }
}
