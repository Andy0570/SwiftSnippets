//
//  PhotoPageContainerViewController.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/6/1.
//

import UIKit

@objc protocol PhotoPageContainerViewControllerDelegate: AnyObject {
    func containerViewController(_ containerViewController: PhotoPageContainerViewController, indexDidUpdate currentIndex: Int)
}

/// Create transition and interaction like iOS Photos app
/// 创建像 iOS Photos 应用一样的过渡和交互
///
/// - SeeAlso: <https://medium.com/@masamichiueta/create-transition-and-interaction-like-ios-photos-app-2b9f16313d3>
class PhotoPageContainerViewController: UIViewController {
    @objc weak var delegate: PhotoPageContainerViewControllerDelegate?

    enum ScreenMode {
        case full, normal
    }
    var currentMode: ScreenMode = .normal {
        didSet {
            switch currentMode {
            case .full:
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.backgroundColor = .black
                }, completion: nil)
            case .normal:
                UIView.animate(withDuration: 0.25, animations: {
                    if #available(iOS 13.0, *) {
                        self.view.backgroundColor = .systemBackground
                    } else {
                        self.view.backgroundColor = .white
                    }
                }, completion: nil)
            }
        }
    }

    @objc var photos: [UIImage]!
    @objc var currentIndex = 0
    var nextIndex: Int?

    var panGestureRecognizer: UIPanGestureRecognizer!
    var singleTapGestureRecognizer: UITapGestureRecognizer!

    @objc var transitionController = ZoomTransitionController()

    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()

    var currentViewController: PhotoZoomViewController {
        guard let viewControllers = self.pageViewController.viewControllers, let zoomViewController = viewControllers.first as? PhotoZoomViewController else {
            fatalError("Can't get current zoom view controller!")
        }
        return zoomViewController
    }

    // MARK: - View Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        currentMode = .normal
        addChild(self.pageViewController)
        view.addSubview(self.pageViewController.view)

        // Pan 手势用于实现下拉交互过渡
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        self.pageViewController.view.addGestureRecognizer(self.panGestureRecognizer)

        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTanWith(gestureRecognizer:)))
        self.pageViewController.view.addGestureRecognizer(self.singleTapGestureRecognizer)

        let zoomViewController = viewPhotoZoomViewController(currentIndex)
        self.pageViewController.setViewControllers([zoomViewController], direction: .forward, animated: true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.pageViewController.view.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Actions

    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            // 平移手势开始时，触发交互式转场
            currentViewController.scrollView.isScrollEnabled = false
            transitionController.isInteractive = true
            navigationController?.popViewController(animated: true)
        case .ended:
            // 平移手势结束时，设置 ZoomTransitionController 退出转场
            if transitionController.isInteractive {
                currentViewController.scrollView.isScrollEnabled = true
                transitionController.isInteractive = false
                transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            // 平移手势执行时，调用 ZoomTransitionController 的 didPanWith() 方法处理交互式转场
            if transitionController.isInteractive {
                transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }

    @objc func didSingleTanWith(gestureRecognizer: UITapGestureRecognizer) {
        switch currentMode {
        case .full:
            currentMode = .normal
        case .normal:
            currentMode = .full
        }
    }

    // MARK: - Private

    private func viewPhotoZoomViewController(_ index: Int) -> PhotoZoomViewController {
        let zoomViewController = PhotoZoomViewController(image: self.photos[index], index: index)
        self.singleTapGestureRecognizer.require(toFail: zoomViewController.doubleTapGestureRecognizer)
        return zoomViewController
    }
}

extension PhotoPageContainerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: view)

            var velocityCheck = false
            if UIDevice.current.orientation.isLandscape {
                velocityCheck = velocity.x < 0
            } else {
                velocityCheck = velocity.y < 0
            }

            if velocityCheck {
                return false
            }
        }

        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == currentViewController.scrollView.panGestureRecognizer {
            if currentViewController.scrollView.contentOffset.y == 0 {
                return true
            }
        }

        return false
    }
}

extension PhotoPageContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PhotoZoomViewController,
            viewController.index > 0 else {
            return nil
        }

        return viewPhotoZoomViewController(viewController.index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PhotoZoomViewController,
            viewController.index + 1 < photos.count else {
            return nil
        }

        return viewPhotoZoomViewController(viewController.index + 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? PhotoZoomViewController else {
            return
        }

        self.nextIndex = nextVC.index
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed && self.nextIndex != nil {
            previousViewControllers.forEach { viewController in
                guard let zoomViewController = viewController as? PhotoZoomViewController else {
                    return
                }
                zoomViewController.scrollView.zoomScale = zoomViewController.scrollView.minimumZoomScale
            }

            if let nextIndex = self.nextIndex {
                self.currentIndex = nextIndex
                self.delegate?.containerViewController(self, indexDidUpdate: self.currentIndex)
            }
        }

        self.nextIndex = nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.photos.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}

extension PhotoPageContainerViewController: ZoomAnimatorDelegate {
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView {
        return currentViewController.imageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect {
        return currentViewController.scrollView.convert(currentViewController.imageView.frame, to: currentViewController.view)
    }

    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }

    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }
}
