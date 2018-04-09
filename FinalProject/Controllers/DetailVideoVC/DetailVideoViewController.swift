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
import SwifterSwift

final class DetailVideoViewController: ViewController, AlertViewController, LoadingViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = DetailVideoViewModel()
    var playerVideoVC: XCDYouTubeVideoPlayerViewController?
    private var viewPlayer = UIView()
    var stateLabel = true

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setUpNavigation()
        tableView.registerCell(aClass: InfoCell.self)
        tableView.registerCell(aClass: DescriptionCell.self)
        tableView.registerCell(aClass: AutoNextVideoCell.self)
        tableView.registerCell(aClass: RelateVideoCell.self)
        tableView.removeHeaderTableView()

        configNotification()
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

    private func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    @objc private func rotatedDevice() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portraitUpsideDown {
            contentView.frame = CGRect(x: 0, y: 0, width: SwifterSwift.screenHeight, height: SwifterSwift.screenWidth)
            playerVideoVC?.moviePlayer.setFullscreen(true, animated: true)
        } else {
            if orientation == .portrait {
                playerVideoVC?.moviePlayer.setFullscreen(false, animated: true)
            } else if orientation == .faceDown {
                playerVideoVC?.moviePlayer.pause()
            } else {
                playerVideoVC?.moviePlayer.play()
            }
        }
    }

    // MARK: - Private func
    @IBAction private func dismissButtonTapped(sender: UIButton) {
        playerVideoVC?.moviePlayer.pause()
        dismiss(animated: true, completion: nil)
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
        playerVideoVC.moviePlayer.controlStyle = .embedded
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
            cell.descriptionLabel.delegate = self
            cell.descriptionLabel.numberOfLines = 2
            cell.descriptionLabel.collapsed = stateLabel
            cell.viewModel = DescriptionCellViewModel(description: viewModel.video?.descript ?? "")
            return cell
        case 2:
            let cell = tableView.dequeueCell(aClass: AutoNextVideoCell.self)
            return cell
        default:
            let cell = tableView.dequeueCell(aClass: RelateVideoCell.self)
            cell.viewModel = RelateVideoCellModel(video: viewModel.relatedVideos[indexPath.row - 3])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailVideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        case 1:
            if stateLabel {
                return 70
            } else {
                return UITableViewAutomaticDimension
            }
        case 2:
            return 40
        default:
            return 90
        }
    }
}

extension DetailVideoViewController: FVReadMoreLabelDelegate {
    func willExpandLabel(_ label: FVReadMoreLabel) {
        tableView.beginUpdates()
    }

    func didExpandLabel(_ label: FVReadMoreLabel) {
        stateLabel = !stateLabel
        tableView.endUpdates()
    }

    func willCollapseLabel(_ label: FVReadMoreLabel) {
        tableView.beginUpdates()
    }

    func didCollapseLabel(_ label: FVReadMoreLabel) {
        stateLabel = !stateLabel
        tableView.endUpdates()
    }

    func shouldCollapseLabel(_ label: FVReadMoreLabel) -> Bool {
        return true
    }
}
