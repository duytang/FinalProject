//
//  DetailVideoViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import PureLayout
import SwifterSwift

final class DetailVideoViewController: ViewController, AlertViewController, LoadingViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var controlView: UIView!
    weak var player: YTSwiftyPlayer?
    
    // MARK: - Properties
    var viewModel = DetailVideoViewModel()
    var stateLabel = true

    var handlePan: ((_ panGestureRecognizer: UIPanGestureRecognizer) -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    deinit {
        kNotification.removeObserver(self)
    }


    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        guard let video = viewModel.video else { return }
        let player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0,
                          width: SwifterSwift.screenWidth,
                          height: SwifterSwift.screenWidth * 2.4 / 4),
            playerVars: [.autoplay(true),
                         .playsInline(true),
                         .loopVideo(true),
                         .showRelatedVideo(false),
                         .videoID(video.idVideo)
                        ])
        self.player = player
        self.player?.delegate = self
        player.loadPlayer()
        contentView.addSubview(player)
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
        favoriteButton.image = viewModel.checkFavorite() ? #imageLiteral(resourceName: "icon-heart-select") : #imageLiteral(resourceName: "ic-favorite")
    }

    func loadData() {
        showLoading()
        viewModel.getRelatedVideos { (result) in
            self.hideLoading()
            switch result {
            case .success:
                self.tableView.reloadData()
                self.tableView.scrollToTop()
            case .failure(let error):
                self.showErrorAlert(message: error.message)
            }
        }
    }

    private func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    // MARK: - Notification for Movie player
    @objc private func rotatedDevice() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portraitUpsideDown {
        } else {
            if orientation == .portrait {
            } else if orientation == .faceDown {
            } else {
            }
        }
    }

    // MARK: - Private func
    func prepareForPlay() {
        guard let video = viewModel.video else { return }
        viewModel.isFavorite = viewModel.checkFavorite()
        favoriteButton.image = viewModel.isFavorite ? #imageLiteral(resourceName: "icon-heart-select") : #imageLiteral(resourceName: "ic-heart")
        player?.loadVideo(videoID: video.idVideo, startSeconds: 0)
    }

    func showButton(alpha: CGFloat) {
        backgroundView.alpha = 1.0
        topView.alpha = alpha
    }

    // MARK: - Actions
    @IBAction private func dismissButtonTapped(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func favoriteButtonTapped(sender: UIButton) {
        guard  let video = viewModel.video else { return }
        if viewModel.isFavorite {
            viewModel.isFavorite = false
            favoriteButton.image = #imageLiteral(resourceName: "ic-heart")
            guard let video = viewModel.videoFavorite(from: video.idVideo) else { return }
            RealmManager.shared.delete(object: video)
            kNotification.post(name: NSNotification.Name(rawValue: NoticationName.reloadFavoriteList), object: nil)
            showAlertView(title: "YouTube", message: "The video has been deleted from the favorite list", cancelButton: "OK")
        } else {
            let addToFavoriteListVC = AddToFavoriteListViewController()
            addToFavoriteListVC.viewModel = AddToFavoriteListViewModel(video: video)
            addToFavoriteListVC.showPopup(inView: self.view, controller: self, delegate: self)
        }
    }
    @IBAction func handlePanAction(_ sender: UIPanGestureRecognizer) {
        handlePan?(sender)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 3 {
            let video = viewModel.relatedVideos[indexPath.row - 3]
            let time = Helper.getCurrentTime()
            let history = History(video: video, time: time.day, day: time.time)
            RealmManager.shared.add(object: history)
            viewModel.getDetailVideo(id: video.idVideo, completion: { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success(let videos):
                    guard let videos = videos as? [Video], let video = videos.first else { return }
                    this.viewModel.video = video
                    this.prepareForPlay()
                    this.loadData()
                case .failure(let error):
                    this.showErrorAlert(message: error.message)
                }
            })
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailVideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 110
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

extension DetailVideoViewController: AddToFavoriteListViewControllerDelegate {
    func favoriteList(controller: AddToFavoriteListViewController, nameList: String) {
        viewModel.isFavorite = true
        favoriteButton.image = #imageLiteral(resourceName: "icon-heart-select")
        showAlertView(title: "YouTube", message: "The video has been saved to the \(nameList) list", cancelButton: "OK")
        kNotification.post(name: NSNotification.Name(NoticationName.reloadFavoriteList),
                           object: nil)
    }
}

extension DetailVideoViewController: YTSwiftyPlayerDelegate {
    func playerReady(_ player: YTSwiftyPlayer) {
//        showButton(alpha: 0)
    }

    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        print("\(#function):\(currentTime)")
    }

    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        print("\(#function):\(state)")
    }

    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        print("\(#function):\(playbackRate)")
    }

    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        print("\(#function):\(error)")
    }

    func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
        print("\(#function):\(quality)")
    }

    func apiDidChange(_ player: YTSwiftyPlayer) {
        print(#function)
    }

    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        print(#function)
    }

    func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
        print(#function)
    }
}
