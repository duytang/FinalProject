//
//  FavoriteListCell.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

final class FavoriteListCell: TableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!

    // MARK: - Property
    var viewModel = FavoriteListCellViewModel() {
        didSet {
            updateUI()
        }
    }

    override func setup() {
        super.setup()
    }

    // MARK: - Private func
    private func updateUI() {
        guard let video = viewModel.video else { return }
        videoImageView.downloadImage(fromURL: video.thumbnail, placeHolder: #imageLiteral(resourceName: "ic_chanel"))
        videoNameLabel.text = video.name
        channelLabel.text = video.channelName
    }
}
