//
//  DetailVideoViewController.swift
//  FinalProject
//
//  Created by Duy Tang on 3/30/18.
//  Copyright © 2018 Duy Tang. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import PureLayout

final class DetailVideoViewController: ViewController, AlertViewController, LoadingViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = DetailVideoViewModel()
    var playerVideoVC: XCDYouTubeVideoPlayerViewController?
    private var viewPlayer = UIView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        tableView.registerCell(aClass: InfoCell.self)
        tableView.registerCell(aClass: DescriptionCell.self)
        tableView.registerCell(aClass: RelateVideoCell.self)
        tableView.rowHeight = 120
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        prepareForPlay()
        viewModel.getRelatedVideos { (result) in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(message: error.message)
            }
        }
    }

    // MARK: - Private func
    private func prepareForPlay() {
        viewPlayer = UIView(frame: CGRect(x: 0, y: 0,
                                          width: contentView.width * App.ratio,
                                          height: contentView.height * App.ratio))
        playerVideoVC?.view.removeFromSuperview()
        guard let video = viewModel.video else { return }
        playerVideoVC = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.idVideo)
        guard let playerVideoVC = playerVideoVC else { return }
        playerVideoVC.present(in: viewPlayer)
        playerVideoVC.moviePlayer.controlStyle = .none
        playerVideoVC.moviePlayer.play()
        contentView.addSubview(viewPlayer)
    }
}

// MARK: - UITableViewDataSource
extension DetailVideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(aClass: InfoCell.self)
            cell.viewModel = InfoCellModel(video: viewModel.video)
            return cell
        case 1:
            let cell = tableView.dequeueCell(aClass: DescriptionCell.self)
            cell.viewModel = DescriptionCellViewModel(description: viewModel.video?.descript ?? "")
            return cell
        default:
            let cell = tableView.dequeueCell(aClass: RelateVideoCell.self)
            cell.viewModel = RelateVideoCellModel(video: viewModel.relatedVideos[indexPath.row - 2])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailVideoViewController: UITableViewDelegate {

}
