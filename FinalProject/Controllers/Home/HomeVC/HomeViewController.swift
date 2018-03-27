//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/26/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var contentView: UIView!

    // MARK: - Properties
    var viewModel = HomeViewModel()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        collectionView.registerCell(aClass: CategoryCollectionCell.self)
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        viewModel.getCategories()
    }
}

// MARK: - Extension
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(aClass: CategoryCollectionCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let category = listCategory![indexPath.row]
//        let textLabel = UILabel()
//        textLabel.text = category.title
//        let labelTextWidth = textLabel.intrinsicContentSize().width
//        return CGSize(width: labelTextWidth + padding * 2, height: collectionView.frame.height)
        return CGSize(width: 60, height: collectionView.frame.height)
    }
}
