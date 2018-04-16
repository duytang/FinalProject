//
//  ContentTableViewCell.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import SwifterSwift

class ContentTableViewCell: TableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var channelImageView: UIImageView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var channelNameLabel: UILabel!
    @IBOutlet private weak var viewNumberLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var infoView: UIView!

    // MARK: - Properties
    var viewModel = ContentTableViewModel() {
        didSet {
            updateUI()
        }
    }

    override func setup() {
        super.setup()
        channelImageView.cornerRadius = channelImageView.frame.width / 2
    }

    private func updateUI() {
        videoImageView.downloadImage(fromURL: viewModel.image)
        channelImageView.downloadImage(fromURL: viewModel.channelImage)
        videoNameLabel.text = viewModel.name
        channelNameLabel.text = viewModel.channelName
        viewNumberLabel.text = viewModel.numberView.convertNumberView() + "・" + viewModel.timeUpload.convertTimeUpload()
        durationLabel.text = viewModel.duration.convertDuration()
    }
}
