//
//  AICustomViewControllerTransition.swift
//  AICustomViewControllerTransition
//
//  Created by cocoatoucher on 09/07/16.
//  Copyright © 2016 cocoatoucher. All rights reserved.
//

import UIKit

public enum TransitionType {
    case simple
    case interactive(isCancelled: Bool, lastPercentage: CGFloat)

    public var isInteractiveTransitionCancelled: Bool? {
        if case let .interactive(isCancelled, _) = self { return isCancelled }
        return nil
    }

    public var lastPercentage: CGFloat? {
        if case let .interactive(_, lastPercentage) = self { return lastPercentage }
        return nil
    }
}

public typealias TransitionViewController = ((_ fromViewController: UIViewController,
    _ toViewController: UIViewController,
    _ containerView: UIView,
    _ transitionType: TransitionType,
    _ completion: @escaping () -> Void) -> Void)

public typealias PercentTransitionViewController = ((_ fromViewController: UIViewController, _ toViewController: UIViewController, _ percentage: CGFloat, _ containerView: UIView) -> Void)

public let defaultDuration: TimeInterval = 0.3
public let maximumPercentage: CGFloat = 1.0
public let minimumPercentage: CGFloat = 0.0

private enum TransitionDirection {
    case none
    case presenting
    case dismissing
}

// MARK: - TransitionState
private enum TransitionState {
    case none
    case start(transitionType: TransitionType)
    case interactivePercentage(currentPercentage: CGFloat)
    case finish(transitionType: TransitionType)
    case cancelInteractive(lastPercentage: CGFloat)

    var isNone: Bool {
        if case .none = self { return true }
        return false
    }

    var isInteractive: Bool {
        switch self {
        case .start(let transitionType):
            if case .interactive = transitionType { return true }
            return false
        case .interactivePercentage: return true
        case .finish(let transitionType):
            if case .interactive = transitionType { return true }
            return false
        case .cancelInteractive: return true
        default: return false
        }
    }

    var percentage: CGFloat? {
        switch self {
        case .start(let transitionType):
            switch transitionType {
            case .interactive(_, let lastPercentage): return lastPercentage
            default:  return nil
            }
        case .interactivePercentage(let currentPercentage): return currentPercentage
        case .finish(let transitionType):
            switch transitionType {
            case .interactive(_, let lastPercentage): return lastPercentage
            default: return nil
            }
        case .cancelInteractive(let lastPercentage): return lastPercentage
        default: return nil
        }
    }

    var isPercentDriven: Bool {
        switch self {
        case .start(let transitionType):
            if case .interactive = transitionType { return true }
            return false
        case .interactivePercentage: return true
        default: return false
        }
    }

    var didTransitionStart: Bool {
        if case .start = self { return true }
        return false
    }

    var didTransitionEnd: Bool {
        switch self {
        case .finish, .cancelInteractive: return true
        default: return false
        }
    }

    var isInteractiveTransitionCancelled: Bool {
        if case .cancelInteractive = self { return true }
        return false
    }
}

// MARK: - ViewControllerTransitionHelper
private class ViewControllerTransitionHelper: NSObject, UIViewControllerAnimatedTransitioning {

    var transitionPresent: TransitionViewController = {(fromViewController: UIViewController,
        toViewController: UIViewController,
        containerView: UIView,
        transitionType: TransitionType,
        completion: @escaping () -> Void) in

        if case .simple = transitionType {
            let beginFrame = containerView.bounds.offsetBy(dx: 0, dy: containerView.bounds.height)
            toViewController.view.frame = beginFrame
        }
        let endFrame: CGRect = containerView.bounds
        UIView.animate(withDuration: defaultDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            toViewController.view.frame = endFrame
        }, completion: { (_) in
            completion()
        })
    }

    var transitionDismiss: TransitionViewController = {(fromViewController: UIViewController,
        toViewController: UIViewController,
        containerView: UIView,
        transitionType: TransitionType,
        completion: @escaping () -> Void) in

        let endFrame = containerView.bounds.offsetBy(dx: 0, dy: containerView.bounds.height)
        UIView.animate(withDuration: defaultDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            fromViewController.view.frame = endFrame
        }, completion: { (_) in
            completion()
        })
    }

    var transitionPercentPresent: PercentTransitionViewController? = {(fromViewController: UIViewController, toViewController: UIViewController, percentage: CGFloat, containerView: UIView) in
        let endFrame = containerView.bounds.offsetBy(dx: 0, dy: containerView.bounds.height * (maximumPercentage - percentage))
        toViewController.view.frame = endFrame
    }

    var transitionPercentDismiss: PercentTransitionViewController? = {(fromViewController: UIViewController, toViewController: UIViewController, percentage: CGFloat, containerView: UIView) in
        let endFrame = containerView.bounds.offsetBy(dx: 0, dy: containerView.bounds.height * percentage)
        fromViewController.view.frame = endFrame
    }

    var transitionDirection: TransitionDirection = .none
    var transitionContext: UIViewControllerContextTransitioning?

    var transitionState: TransitionState = .none {
        didSet {
            guard !self.transitionState.isNone else { return }
            guard let transitionContext = self.transitionContext else { return }
            let containerView = transitionContext.containerView
            let didTransitionStart = self.transitionState.didTransitionStart
            let isPercentDriven = self.transitionState.isPercentDriven
            let didTransitionEnd = self.transitionState.didTransitionEnd
            let isInteractiveTransitionCancelled = self.transitionState.isInteractiveTransitionCancelled
            let isInteractive = self.transitionState.isInteractive
            let percentage = self.transitionState.percentage

            guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
            guard let toViewController = transitionContext.viewController(forKey: .to) else { return }

            switch self.transitionDirection {
            case .presenting:
                if didTransitionStart {
                    fromViewController.view.frame = containerView.convert(fromViewController.view.frame, from: fromViewController.view.superview)
                    containerView.addSubview(fromViewController.view)
                    containerView.addSubview(toViewController.view)
                } else if didTransitionEnd && !isInteractive {
                    containerView.addSubview(toViewController.view)
                }
            case .dismissing:
                if didTransitionStart {
                    toViewController.view.frame = containerView.bounds

                    if !isInteractive {
                        containerView.insertSubview(toViewController.view, at: 0)
                    } else {
                        containerView.insertSubview(toViewController.view, at: 0)
                        containerView.addSubview(fromViewController.view)
                    }
                }
            default: break
            }
            fromViewController.view.isUserInteractionEnabled = false

            let completion = {
                if transitionContext.transitionWasCancelled {
                    if isInteractive {
                        transitionContext.cancelInteractiveTransition()
                    }
                    transitionContext.completeTransition(false)

                    guard let window = UIApplication.shared.keyWindow else { return }
                    if isInteractive {
                        toViewController.view.frame = window.convert(toViewController.view.frame, from: toViewController.view.superview ?? window)
                        window.addSubview(toViewController.view)
                    }
                    fromViewController.view.frame = window.convert(fromViewController.view.frame, from: fromViewController.view.superview ?? containerView)
                    window.addSubview(fromViewController.view)
                } else {
                    if isInteractive {
                        transitionContext.finishInteractiveTransition()
                    }
                    transitionContext.completeTransition(true)

                    guard let window = UIApplication.shared.keyWindow else { return }
                    if isInteractive {
                        fromViewController.view.frame = window.convert(fromViewController.view.frame, from: fromViewController.view.superview ?? containerView)
                        window.addSubview(fromViewController.view)
                    }
                    toViewController.view.frame = window.convert(toViewController.view.frame, from: toViewController.view.superview ?? window)
                    window.addSubview(toViewController.view)
                }

                fromViewController.view.isUserInteractionEnabled = true

                self.transitionDirection = .none
                self.transitionContext = nil
                self.transitionState = .none
            }

            if !isPercentDriven {
                var animatePresenting = transitionDirection == .presenting
                var reverseFromAndToViewControllers = false
                if isInteractiveTransitionCancelled {
                    reverseFromAndToViewControllers = true
                    switch transitionDirection {
                    case .presenting:
                        animatePresenting = false
                    case .dismissing:
                        animatePresenting = true
                    default:
                        break
                    }
                }

                let reversedFromViewController = reverseFromAndToViewControllers ? toViewController : fromViewController
                let reversedToViewController = reverseFromAndToViewControllers ? fromViewController : toViewController

                let transitionType: TransitionType = isInteractive ? .interactive(isCancelled: isInteractiveTransitionCancelled, lastPercentage: percentage!) : .simple

                if animatePresenting {
                    transitionPresent(reversedFromViewController,
                                      reversedToViewController,
                                      containerView,
                                      transitionType,
                                      completion
                                     )
                } else {
                    transitionDismiss(reversedFromViewController,
                                      reversedToViewController,
                                      containerView,
                                      transitionType,
                                      completion
                                     )
                }
            } else {
                switch transitionDirection {
                case .presenting:
                    transitionPercentPresent?(fromViewController, toViewController, percentage!, containerView)
                case .dismissing:
                    transitionPercentDismiss?(fromViewController, toViewController, percentage!, containerView)
                default: break
                }
                fromViewController.view.isUserInteractionEnabled = true
            }
        }
    }

    // MARK: - UIViewControllerAnimatedTransitioning
    @objc fileprivate func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.0
    }

    @objc fileprivate func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard !transitionContext.isInteractive else { return }
        self.transitionContext = transitionContext
        switch transitionDirection {
        case .presenting:
            transitionState = .finish(transitionType: .simple)
        case .dismissing:
            transitionState = .start(transitionType: .simple)
        default: break
        }
    }
}

// MARK: - SimpleTransitioningDelegate
open class SimpleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    open var isPresenting: Bool {
        return transitionHelper.transitionDirection == .presenting
    }

    open var isDismissing: Bool {
        return transitionHelper.transitionDirection == .dismissing
    }

    open var transitionPresent: TransitionViewController {
        get {
            return transitionHelper.transitionPresent
        }
        set {
            transitionHelper.transitionPresent = newValue
        }
    }
    open var transitionDismiss: TransitionViewController {
        get {
            return transitionHelper.transitionDismiss
        }
        set {
            transitionHelper.transitionDismiss = newValue
        }
    }

    fileprivate let transitionHelper: ViewControllerTransitionHelper = ViewControllerTransitionHelper()

    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionHelper.transitionDirection = .presenting
        return transitionHelper
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionHelper.transitionDirection = .dismissing
        return transitionHelper
    }
}

// MARK: - InteractiveTransitioningDelegate
open class InteractiveTransitioningDelegate: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {
    open var isPresenting: Bool {
        return transitionHelper.transitionDirection == .presenting
    }

    open var isDismissing: Bool {
        return transitionHelper.transitionDirection == .dismissing
    }

    open var transitionPresent: TransitionViewController {
        get {
            return transitionHelper.transitionPresent
        }
        set {
            transitionHelper.transitionPresent = newValue
        }
    }

    open var transitionDismiss: TransitionViewController {
        get {
            return transitionHelper.transitionDismiss
        }
        set {
            transitionHelper.transitionDismiss = newValue
        }
    }

    open var transitionPercentPresent: PercentTransitionViewController? {
        get {
            return transitionHelper.transitionPercentPresent
        }
        set {
            transitionHelper.transitionPercentPresent = newValue
        }
    }
    open var transitionPercentDismiss: PercentTransitionViewController? {
        get {
            return transitionHelper.transitionPercentDismiss
        }
        set {
            transitionHelper.transitionPercentDismiss = newValue
        }
    }

    fileprivate let transitionHelper: ViewControllerTransitionHelper = ViewControllerTransitionHelper()
    fileprivate var isInteractiveTransition: Bool = false

    open func beginPresenting(viewController: UIViewController, fromViewController: UIViewController) {
        if transitionHelper.transitionContext != nil && transitionHelper.transitionContext!.isInteractive {
            return
        }
        isInteractiveTransition = true
        fromViewController.present(viewController, animated: true, completion: nil)
    }

    open func beginDismissing(viewController: UIViewController) {
        if transitionHelper.transitionContext != nil && transitionHelper.transitionContext!.isInteractive {
            return
        }
        isInteractiveTransition = true
        viewController.dismiss(animated: true, completion: nil)
    }
    open func finalizeInteractiveTransition(isTransitionCompleted completed: Bool) {
        if completed {
            finish()
        } else {
            cancel()
        }
    }

    // MARK: UIViewControllerTransitioningDelegate
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if isInteractiveTransition {
            return transitionHelper
        }

        if transitionHelper.transitionDirection != .presenting {
            transitionHelper.transitionDirection = .presenting
            return transitionHelper
        }
        return nil
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if isInteractiveTransition {
            return transitionHelper
        }

        if transitionHelper.transitionDirection != .dismissing {
            transitionHelper.transitionDirection = .dismissing
            return transitionHelper
        }
        return nil
    }

    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if transitionHelper.transitionDirection != .presenting {
            transitionHelper.transitionDirection = .presenting
            return self
        }
        return nil
    }

    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if transitionHelper.transitionDirection != .dismissing {
            transitionHelper.transitionDirection = .dismissing
            return self
        }
        return nil
    }

    // MARK: UIPercentDrivenInteractiveTransition
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        transitionHelper.transitionContext = transitionContext
        transitionHelper.transitionState = .start(transitionType: .interactive(isCancelled: false, lastPercentage: 0))
    }

    open override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        transitionHelper.transitionState = .interactivePercentage(currentPercentage: percentComplete)
    }

    open override func finish() {
        super.finish()
        isInteractiveTransition = false
        transitionHelper.transitionState = .finish(transitionType: .interactive(isCancelled: false,
                                                                                lastPercentage: percentComplete))
    }

    open override func cancel() {
        super.cancel()
        isInteractiveTransition = false
        transitionHelper.transitionState = .cancelInteractive(lastPercentage: percentComplete)
    }
}
