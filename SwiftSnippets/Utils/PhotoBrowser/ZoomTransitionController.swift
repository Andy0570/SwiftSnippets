//
//  ZoomTransitionController.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/6/1.
//

import UIKit

/// 转场控制器
class ZoomTransitionController: NSObject {
    let animator: ZoomAnimator
    let interactionController: ZoomDismissalInteractionController
    var isInteractive = false

    @objc weak var fromDelegate: ZoomAnimatorDelegate?
    @objc weak var toDelegate: ZoomAnimatorDelegate?

    override init() {
        animator = ZoomAnimator()
        interactionController = ZoomDismissalInteractionController()
        super.init()
    }

    // Add wrapper to call didPanWith in ZoomDismissalInteractionController
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        interactionController.didPanWith(gestureRecognizer: gestureRecognizer)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ZoomTransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = true
        animator.fromDelegate = fromDelegate
        animator.toDelegate = toDelegate
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresenting = false
        animator.fromDelegate = toDelegate
        animator.toDelegate = fromDelegate
        return animator
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !isInteractive {
            return nil
        }
        interactionController.animator = animator
        return interactionController
    }
}

// MARK: - UINavigationControllerDelegate

extension ZoomTransitionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            animator.isPresenting = true
            animator.fromDelegate = fromDelegate
            animator.toDelegate = toDelegate
        } else {
            animator.isPresenting = false
            animator.fromDelegate = toDelegate
            animator.toDelegate = fromDelegate
        }
        return animator
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !isInteractive {
            return nil
        }
        interactionController.animator = animator
        return interactionController
    }
}