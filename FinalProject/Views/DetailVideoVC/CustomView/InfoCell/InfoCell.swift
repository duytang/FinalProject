//
//  InfoCell.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/7/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

class InfoCell: TableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var numberViewLabel: UILabel!
    @IBOutlet private weak var channelNameLabel: UILabel!
    @IBOutlet private weak var publicTimeLabel: UILabel!
    @IBOutlet private weak var channelImageView: UIImageView!

    // MARK: - Property
    var viewModel = InfoCellModel() {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        videoNameLabel.text = viewModel.videoName
        numberViewLabel.text = viewModel.numberView.convertNumberView()
        channelImageView.downloadImage(fromURL: viewModel.channelImage, placeHolder: #imageLiteral(resourceName: "ic_chanel"))
        channelNameLabel.text = viewModel.channelName
        publicTimeLabel.text = viewModel.publicAt
    }
}
