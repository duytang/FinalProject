//
//  DetailVideoViewController.swift
//  FinalProject
//
//  Created by Kieu Nhi on 3/30/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit
import XCDYouTubeKit
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
    
    // MARK: - Properties
    var viewModel = DetailVideoViewModel()
    var playerVideoVC: XCDYouTubeVideoPlayerViewController?
    private var viewPlayer = UIView()
    var stateLabel = true
    var isPlaying = true

    var handlePan: ((_ panGestureRecognizer: UIPanGestureRecognizer) -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    deinit {
        kNotification.removeObserver(self)
    }

    // MARK: - Setup Data
    override func setupData() {
        super.setupData()
        prepareForPlay()
        loadData()
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moviePlayerNowPlayingMovieDidChange),
                                               name: .MPMoviePlayerNowPlayingMovieDidChange,
                                               object: playerVideoVC?.moviePlayer)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moviePlayerLoadStateDidChange),
                                               name: .MPMoviePlayerLoadStateDidChange,
                                               object: playerVideoVC?.moviePlayer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moviePlayerPlaybackDidChange),
                                               name: .MPMoviePlayerPlaybackStateDidChange,
                                               object: playerVideoVC?.moviePlayer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moviePlayerPlayBackDidFinish),
                                               name: .MPMoviePlayerPlaybackDidFinish,
                                               object: playerVideoVC?.moviePlayer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieEnterScreen),
                                               name: .MPMoviePlayerDidEnterFullscreen,
                                               object: playerVideoVC?.moviePlayer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieExitFullScreen),
                                               name: .MPMoviePlayerDidExitFullscreen,
                                               object: playerVideoVC?.moviePlayer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeVideo),
                                               name: .XCDYouTubeVideoPlayerViewControllerDidReceiveVideo,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    // MARK: - Notification for Movie player
    @objc private func moviePlayerNowPlayingMovieDidChange(notification: Notification) { }

    @objc private func moviePlayerLoadStateDidChange(notification: NSNotification) {
        guard let state = playerVideoVC?.moviePlayer.playbackState else { return }
        switch state {
        case .stopped, .interrupted, .seekingForward, .seekingBackward, .paused: break
        case.playing:
            controlView.alpha = 0
        }
    }

    @objc private func moviePlayerPlaybackDidChange(notification: NSNotification) {
        guard let state = playerVideoVC?.moviePlayer.playbackState else { return }
        print(state)
        switch state {
        case .stopped, .interrupted, .seekingForward, .seekingBackward, .paused:
            break
        case .playing:
            print("readyy")
            controlView.alpha = 0
//            indicator.stopAnimating()
//            playButton.setImage(UIImage(named: "bt_pause"), forState: .Normal)
//            changStatusButton(false)
            break
        }
    }

    @objc private func moviePlayerPlayBackDidFinish(notification: NSNotification) {
//        handleNext()
    }

    @objc private func movieEnterScreen() {
        playerVideoVC?.moviePlayer.setFullscreen(true, animated: true)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    @objc private func movieExitFullScreen() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        playerVideoVC?.moviePlayer.isFullscreen = false
    }

    @objc private func changeVideo(notification: NSNotification) {
        DispatchQueue.main.async {
            self.playerVideoVC?.moviePlayer.prepareToPlay()
        }
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
    func prepareForPlay() {
        viewPlayer = UIView(frame: CGRect(x: 0, y: 0,
                                          width: SwifterSwift.screenWidth,
                                          height: SwifterSwift.screenWidth * 2.25 / 4))
        playerVideoVC?.view.removeFromSuperview()
        guard let video = viewModel.video else { return }
        playerVideoVC = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.idVideo)
        guard let playerVideoVC = playerVideoVC else { return }
        playerVideoVC.present(in: viewPlayer)

        playerVideoVC.moviePlayer.controlStyle = .none
        playerVideoVC.moviePlayer.play()
        contentView.addSubview(viewPlayer)
    }

    func showButton(alpha: CGFloat) {
        backgroundView.alpha = 1.0
        topView.alpha = alpha
//        dismissButton.alpha = alpha
//        favoriteButton.alpha = alpha
//        playButton.alpha = alpha
//        nextButton.alpha = alpha
//        previousButton.alpha = alpha
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
    
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIView.animate(withDuration: 0.5, animations: {
            UIDevice.current.setValue(value, forKey: "orientation")
        }) { (_) in
            self.contentView.frame = CGRect(x: 0, y: 0, width: SwifterSwift.screenHeight, height: SwifterSwift.screenWidth)
        }

    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        _ = isPlaying ? playerVideoVC?.moviePlayer.pause() : playerVideoVC?.moviePlayer.play()
        isPlaying = !isPlaying
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

extension DetailVideoViewController: AddToFavoriteListViewControllerDelegate {
    func favoriteList(controller: AddToFavoriteListViewController, nameList: String) {
        viewModel.isFavorite = true
        favoriteButton.image = #imageLiteral(resourceName: "icon-heart-select")
        showAlertView(title: "YouTube", message: "The video has been saved to the \(nameList) list", cancelButton: "OK")
        kNotification.post(name: NSNotification.Name(NoticationName.reloadFavoriteList),
                           object: nil)
    }
}
