//
//  InfoCell.swift
//  FinalProject
//
//  Created by Duy Tang on 4/7/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

class InfoCell: TableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var numberViewLabel: UILabel!
    @IBOutlet private weak var channelNameLabel: UILabel!
    @IBOutlet private weak var numberSubscribeLabel: UILabel!
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
        numberSubscribeLabel.text = viewModel.publicAt
    }
}
