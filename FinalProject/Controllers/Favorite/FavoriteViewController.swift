//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/27/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit

class FavoriteViewController: ViewController {
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
        collectionView.registerCell(aClass: CreateFolderCell.self)
        collectionView.registerCell(aClass: FavoriteCollectionViewCell.self)
        addRightBarButton(image: #imageLiteral(resourceName: "ic_delete"), action: #selector(deleteAll))
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
    }

    // MARK: - Private func
    @objc private func deleteAll() {

    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueCell(aClass: CreateFolderCell.self, indexPath: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueCell(aClass: FavoriteCollectionViewCell.self, indexPath: indexPath)
            return cell
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("creeate new folder")
        } else {
            let favoriteListVC = FavoriteListViewController()
            push(viewController: favoriteListVC)
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width / 2)
    }
}
