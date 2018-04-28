//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/27/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

final class FavoriteViewController: ViewController, AlertViewController {
    // MARK: - Outlets
    @IBOutlet private  weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel = FavoriteViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        title = Title.favorite
        collectionView.registerCell(aClass: FavoriteCollectionViewCell.self)
        kNotification.addObserver(self,
                                  selector: #selector(loadData),
                                  name: NSNotification.Name(NoticationName.reloadFavoriteList),
                                  object: nil)
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        loadData()
    }

   @objc private func loadData() {
        viewModel.getData()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(aClass: FavoriteCollectionViewCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoriteListVC = FavoriteListViewController()
        let favorite = viewModel.favoriteList[indexPath.row]
        favoriteListVC.viewModel = FavoriteListViewModel(favorite: favorite)
        push(viewController: favoriteListVC)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 8, height: collectionView.frame.width / 2 + 32 )
    }
}
