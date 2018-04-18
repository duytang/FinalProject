//
//  DragVideoManager.swift
//  FinalProject
//
//  Created by Kieu Nhi on 4/15/18.
//  Copyright © 2018 Kieu Nhi. All rights reserved.
//

import UIKit

enum VideoPositionType {
    case leftTop
    case rightTop
    case leftBottom
    case rightBottom
}

class DraggalbeVideoManager {

    private var thumbnailView: UIView? = AppDelegate.shared.thumbnailView
    let delegate: InteractiveTransitioningDelegate = InteractiveTransitioningDelegate()
    private var parentVC: UIViewController!
    var lastPoint: CGPoint = .zero

    lazy var videoPlayerVC: DetailVideoViewController = {
        let vc = AppDelegate.shared.videoDetailVC
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = delegate
        vc.handlePan = { (panGestureRecozgnizer) in
            let translatedPoint = panGestureRecozgnizer.translation(in: self.parentVC.view)

            switch panGestureRecozgnizer.state {
            case .began:
                self.delegate.beginDismissing(viewController: vc)
                self.lastVideoPlayerOriginY = vc.view.frame.origin.y
            case .changed:
                guard let thumbnail = self.thumbnailView else { return }
                let ratio = max(min(((self.lastVideoPlayerOriginY + translatedPoint.y) / thumbnail.frame.minY), 1), 0)
                self.lastPanRatio = ratio
                self.delegate.update(self.lastPanRatio)
            case .ended:
                let completed = (self.lastPanRatio > self.panRatioThreshold) || (self.lastPanRatio < -self.panRatioThreshold)
                self.delegate.finalizeInteractiveTransition(isTransitionCompleted: completed)
            default: break
            }
        }
        return vc
    }()

    private let panRatioThreshold: CGFloat = 0.3
    private var lastPanRatio: CGFloat = 0.0
    private var lastVideoPlayerOriginY: CGFloat = 0.0
    private var initialFrame: CGRect?

    init(rootViewController: UIViewController) {
        self.parentVC = rootViewController
    }

    func draggbleProgress() {
        delegate.transitionPresent = { [weak self](fromViewController: UIViewController,
            toViewController: UIViewController, containerView: UIView, transitionType: TransitionType, completion: @escaping () -> Void) in
            guard let this = self else { return }
            guard let videoPlayerVC = toViewController as? DetailVideoViewController else { return }
            if case .simple = transitionType {
                if this.initialFrame != nil {
                    guard let thumbnail = this.initialFrame else { return }
                    videoPlayerVC.view.frame = thumbnail
                    this.initialFrame = nil
                } else {
                    videoPlayerVC.view.frame = containerView.bounds.offsetBy(dx: 0,
                                                                             dy: videoPlayerVC.view.frame.height)
                    videoPlayerVC.backgroundView.alpha = 0.0
                }
            }
            UIView.animate(withDuration: defaultDuration, animations: {
                videoPlayerVC.view.transform = CGAffineTransform.identity
                videoPlayerVC.view.frame = containerView.bounds
                videoPlayerVC.showButton(alpha: 1.0)
            }, completion: { (_) in
                completion()
                videoPlayerVC.view.isUserInteractionEnabled = true
            })
        }
        delegate.transitionDismiss = { [weak self](fromViewController: UIViewController,
            toViewController: UIViewController,
            containerView: UIView,
            transitionType: TransitionType,
            completion: @escaping () -> Void) in

            guard let this = self else { return }
            guard let videoPlayerVC = fromViewController as? DetailVideoViewController else { return }
            let videoPlayerBounds = videoPlayerVC.view.bounds
            guard let thumbnail = this.thumbnailView else { return }
            let finalTransform = CGAffineTransform(scaleX: thumbnail.bounds.width / videoPlayerBounds.width,
                                                   y: thumbnail.bounds.height * 3 / videoPlayerBounds.height)

            UIView.animate(withDuration: defaultDuration, animations: {
                videoPlayerVC.view.transform = finalTransform
                var finalRect = videoPlayerVC.view.frame
                finalRect.origin.x = thumbnail.frame.minX
                finalRect.origin.y = thumbnail.frame.minY
                videoPlayerVC.view.frame = finalRect
                videoPlayerVC.showButton(alpha: 0.0)

            }, completion: { (_) in
                completion()
                videoPlayerVC.view.isUserInteractionEnabled = false
                this.parentVC?.addChildViewController(videoPlayerVC)
                var thumbnailRect = videoPlayerVC.view.frame
                thumbnailRect.origin = .zero
                videoPlayerVC.view.frame = thumbnailRect

                thumbnail.addSubview(fromViewController.view)
                fromViewController.didMove(toParentViewController: this.parentVC)
            })
        }

        delegate.transitionPercentPresent = { [weak self](fromViewController: UIViewController,
            toViewController: UIViewController,
            percentage: CGFloat,
            containerView: UIView) in

            guard let this = self, let videoPlayerVC = toViewController as? DetailVideoViewController else { return }
            if let initialFrame = this.initialFrame {
                videoPlayerVC.view.frame = initialFrame
                this.initialFrame = nil
            }

            guard let thumbnail = this.thumbnailView else { return }
            let startXScale = thumbnail.bounds.width / containerView.bounds.width
            let startYScale = thumbnail.bounds.height * 3 / containerView.bounds.height
            let xScale = startXScale + ((1 - startXScale) * percentage)
            let yScale = startYScale + ((1 - startYScale) * percentage)
            toViewController.view.transform = CGAffineTransform(scaleX: xScale, y: yScale)

            let startXPos = thumbnail.frame.minX
            let startYPos = thumbnail.frame.minY
            let horizontalMove = startXPos - (startXPos * percentage)
            let verticalMove = startYPos - (startYPos * percentage)

            var finalRect = toViewController.view.frame
            finalRect.origin.x = horizontalMove
            finalRect.origin.y = verticalMove
            toViewController.view.frame = finalRect
            videoPlayerVC.backgroundView.alpha = percentage
        }

        delegate.transitionPercentDismiss = { [weak self](fromViewController: UIViewController,
            toViewController: UIViewController,
            percentage: CGFloat,
            containerView: UIView) in

            guard let this = self,
                let videoPlayerVC = fromViewController as? DetailVideoViewController,
                let thumbnail = this.thumbnailView else { return }

            let videoPlayerBounds = videoPlayerVC.view.bounds

            let finalXScale = thumbnail.bounds.width / videoPlayerBounds.width
            let finalYScale = thumbnail.bounds.height * 3 / videoPlayerBounds.height

            let xScale = 1 - (percentage * (1 - finalXScale))
            let yScale = 1 - (percentage * (1 - finalYScale))
            videoPlayerVC.view.transform = CGAffineTransform(scaleX: xScale, y: yScale)

            let finalXPos = thumbnail.frame.minX
            let finalYPos = thumbnail.frame.minY
            let horizontalMove = min(thumbnail.frame.minX * percentage, finalXPos)
            let verticalMove = min(thumbnail.frame.minY * percentage, finalYPos)

            var finalRect = videoPlayerVC.view.frame
            finalRect.origin.x = horizontalMove
            finalRect.origin.y = verticalMove
            videoPlayerVC.view.frame = finalRect

            videoPlayerVC.backgroundView.alpha = 1 - percentage
            videoPlayerVC.dismissButton.alpha = 1 - percentage
        }
    }

    func addActionToView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentFromThumbnail))
        thumbnailView?.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        thumbnailView?.addGestureRecognizer(pan)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exitPLayerVideo))
        thumbnailView?.addGestureRecognizer(longPress)
    }

    @objc private func presentFromThumbnail(sender: UITapGestureRecognizer? = nil) {
        guard videoPlayerVC.parent != nil,
            let thumbnail = thumbnailView else { return }
        initialFrame = thumbnail.convert(videoPlayerVC.view.frame, to: parentVC.view)
        videoPlayerVC.removeFromParentViewController()
        parentVC.present(videoPlayerVC, animated: true, completion: nil)
    }

    @objc private func handlePresentPan(panGestureRecozgnizer: UIPanGestureRecognizer) {
        guard videoPlayerVC.parent != nil || delegate.isPresenting else {
            return
        }

        guard let thumbnail = thumbnailView else { return }
        let translatedPoint = panGestureRecozgnizer.translation(in: parentVC.view)

        switch panGestureRecozgnizer.state {
        case .began:
            initialFrame = thumbnail.convert(videoPlayerVC.view.frame, to: parentVC.view)
            videoPlayerVC.removeFromParentViewController()
            delegate.beginPresenting(viewController: videoPlayerVC, fromViewController: parentVC)
            initialFrame = thumbnail.convert(videoPlayerVC.view.frame, to: parentVC.view)
            guard let initialFrame = initialFrame else { return }
            lastVideoPlayerOriginY = initialFrame.origin.y
        case .changed:
            guard let thumbnail = thumbnailView else { return }
            let ratio = max(min(((lastVideoPlayerOriginY + translatedPoint.y) / thumbnail.frame.minY), 1), 0)
            lastPanRatio = 1 - ratio
            delegate.update(lastPanRatio)
        case .ended:
            let completed = lastPanRatio > panRatioThreshold || lastPanRatio < -panRatioThreshold
            delegate.finalizeInteractiveTransition(isTransitionCompleted: completed)
        default: break
        }
    }

    @objc private func pan(gesture: UIPanGestureRecognizer) {
        guard let thumbnail = thumbnailView else { return }
        let point = gesture.location(in: thumbnail)
        let velocity = gesture.velocity(in: thumbnail)

        switch gesture.state {
        case .began:
            lastPoint = point
        case .changed:
            thumbnail.center.x += point.x - lastPoint.x
            thumbnail.center.y += point.y - lastPoint.y
        case .ended , .cancelled:
            let rect = thumbnail.frame
            let center = thumbnail.center

            let size = UIScreen.main.bounds
            let halfSize = size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))

//            if center.x < halfSize.width && center.y < halfSize.height {
//                self.setFrameWith(quadrant: .leftTop, dismissVideo: velocity.x < 0 && rect.origin.x < 0)
//            } else if center.x > halfSize.width && center.y < halfSize.height {
//                self.setFrameWith(quadrant: .rightTop, dismissVideo: velocity.x > 0 && rect.maxX > size.width)
//            } else if center.x < halfSize.width && center.y > halfSize.height {
//                self.setFrameWith(quadrant: .leftBottom, dismissVideo: velocity.x < 0 && rect.origin.x < 0)
//            } else if center.x > halfSize.width && center.y > halfSize.height{
//                self.setFrameWith(quadrant: .rightBottom, dismissVideo: velocity.x > 0 && rect.maxX > size.width)
//            }
            lastPoint = .zero
        default:
            break
        }
    }

    @objc private func exitPLayerVideo(swipeGesture: UISwipeGestureRecognizer) {
        let alert = UIAlertController(title: "Youtube", message: "Would you like to exit play video", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.videoPlayerVC.playerVideoVC?.moviePlayer.pause()
            self.videoPlayerVC.view.removeFromSuperview()
            self.videoPlayerVC.removeFromParentViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        parentVC.present(alert, animated: true, completion: nil)
    }

    func prensentDetailVideoVC(video: Video) {
        if videoPlayerVC.parent != nil {
            initialFrame = thumbnailView?.convert(videoPlayerVC.view.frame, to: parentVC.view)
            videoPlayerVC.removeFromParentViewController()
        }
        videoPlayerVC.viewModel.video = video
        videoPlayerVC.loadData()
        videoPlayerVC.prepareForPlay()
        videoPlayerVC.viewModel.checkFavorite()

//        videoPlayerViewController.checkFavorite(video.idVideo)
//        videoPlayerViewController.setImageForFavoriteButton()
//        History.addVideoToHistory(video)
        parentVC.present(videoPlayerVC, animated: true, completion: nil)
    }
}
