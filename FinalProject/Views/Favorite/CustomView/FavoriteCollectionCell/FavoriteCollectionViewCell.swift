//
//  FavoriteCollectionViewCell.swift
//  FinalProject
//
//  Created by Duy Tang on 3/28/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class FavoriteCollectionViewCell: CollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var firstVideoImageView: UIImageView!
    @IBOutlet weak var secondVideoImageView: UIImageView!
    @IBOutlet weak var thirdVideoImageView: UIImageView!
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
            secondVideoImageView.isHidden = true
            thirdVideoImageView.isHidden = true
            moreVideoLabel.frame = frame
            moreVideoLabel.text = "No video"
        case 1:
            firstVideoImageView.isHidden = false
            secondVideoImageView.isHidden = true
            thirdVideoImageView.isHidden = true
            moreVideoLabel.isHidden = true
            firstVideoImageView.downloadImage(fromURL: favoriteList.listVideo[0].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
        case 2:
            firstVideoImageView.isHidden = false
            secondVideoImageView.isHidden = false
            thirdVideoImageView.isHidden = true
            moreVideoLabel.isHidden = true
            firstVideoImageView.downloadImage(fromURL: favoriteList.listVideo[0].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            secondVideoImageView.downloadImage(fromURL: favoriteList.listVideo[1].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
        case 3:
            firstVideoImageView.isHidden = false
            secondVideoImageView.isHidden = false
            thirdVideoImageView.isHidden = false
            moreVideoLabel.isHidden = true
            firstVideoImageView.downloadImage(fromURL: favoriteList.listVideo[0].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            secondVideoImageView.downloadImage(fromURL: favoriteList.listVideo[1].thumbnail,
                                               placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            thirdVideoImageView.downloadImage(fromURL: favoriteList.listVideo[2].thumbnail,
                                               placeHolder: #imageLiteral(resourceName: "ic_chanel"))
        default:
            firstVideoImageView.isHidden = false
            secondVideoImageView.isHidden = false
            thirdVideoImageView.isHidden = false
            firstVideoImageView.downloadImage(fromURL: favoriteList.listVideo[0].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            secondVideoImageView.downloadImage(fromURL: favoriteList.listVideo[1].thumbnail,
                                               placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            thirdVideoImageView.downloadImage(fromURL: favoriteList.listVideo[2].thumbnail,
                                              placeHolder: #imageLiteral(resourceName: "ic_chanel"))
            let count = favoriteList.listVideo.count - 3
            moreVideoLabel.text = "+ \(count)"
        }
    }
}
