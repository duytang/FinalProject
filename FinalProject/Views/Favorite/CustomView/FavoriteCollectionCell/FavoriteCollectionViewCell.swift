//
//  FavoriteCollectionViewCell.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/28/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

final class FavoriteCollectionViewCell: CollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var firstVideoImageView: UIImageView!
    @IBOutlet weak var moreVideoLabel: UILabel!
    @IBOutlet weak var favoriteListNameLabel: UILabel!

    // MARK: - Property
    var viewModel = FavoriteCollectionViewModel() {
        didSet {
            updateUI()
        }
    }

    // MARK: - Private func
    private func updateUI() {
        guard let favoriteList = viewModel.favoriteList else { return }
        favoriteListNameLabel.text = favoriteList.name
        switch favoriteList.listVideo.count {
        case 0:
            firstVideoImageView.isHidden = true
            moreVideoLabel.frame = frame
            moreVideoLabel.text = "No video"
        default:
            firstVideoImageView.isHidden = false
            firstVideoImageView.downloadImage(fromURL: favoriteList.listVideo[0].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            let count = favoriteList.listVideo.count - 1
            if count > 0 {
                let text = count == 1 ? "+1 video": "+\(count) videos"
                 moreVideoLabel.text = text
            }
        }
    }
}
