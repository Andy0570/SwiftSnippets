//
//  FoxMarqueeView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/4/29.
//

import UIKit

public protocol FoxMarqueeViewCopyable {
    func copyMarqueeView() -> UIView
}

extension UIView: FoxMarqueeViewCopyable {
    @objc open func copyMarqueeView() -> UIView {
        // 使用快照创建跑马灯副本
        layoutIfNeeded()
        let targetSize = bounds.size
        guard targetSize.width > 0, targetSize.height > 0 else {
            return UIView(frame: bounds)
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let image = renderer.image { _ in
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }

        let imageView = UIImageView(image: image)
        imageView.frame = bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = clipsToBounds
        imageView.backgroundColor = .clear
        return imageView
    }
}

public enum FoxMarqueeDirection {
    case left
    case right
    case reverse
}

/// 跑马灯视图
/// 
/// Reference: <https://github.com/pujiaxin33/JXMarqueeView>
public class FoxMarqueeView: UIView {
    public var marqueeDirection: FoxMarqueeDirection = .left
    // 两个视图直接的间距
    public var contentMargin: CGFloat = 12.0
    // 多少帧回调一次，普通设备是一帧时间1/60秒，高刷频设备默认为设备自身的刷新率
    public var preferredFramesPerSecond: Int = 0
    // 每次回调移动的像素点
    public var pointsPerFrame: CGFloat = 1.0
    // 自定义跑马灯视图，支持任意 UIView 类型
    public var contentView: UIView? {
        didSet {
            self.setNeedsLayout()
        }
    }
    // 当 contentView 的内容宽度没有超过显示宽度，无需开启跑马灯效果。这个时候 contentView 的size，默认是调用 sizeToFit 之后的尺寸。
    // 如果想要特殊配置，比如让 contentView 的 size 等于 FoxMarqueeView，就需要在该闭包自定义配置。
    public var contentViewFrameConfigWhenCantMarquee: ((UIView) -> Void)?
    private let containerView = UIView()
    private var marqueeDisplayLink: CADisplayLink?
    private var isReversing = false

    override public func willMove(toSuperview newSuperview: UIView?) {
        // 当视图将被移出父视图的时候，newSuperview 就为 nil。在这个时候，停止 CADisplayLink，断开循环引用，视图就可以被正确释放掉了。
        if newSuperview == nil {
            self.stopMarquee()
        }
    }

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.clear
        self.clipsToBounds = true

        containerView.backgroundColor = UIColor.clear
        addSubview(containerView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        guard let validContentView = contentView else {
            return
        }
        containerView.subviews.forEach { $0.removeFromSuperview() }

        // 对于复杂视图，需要自己重写 contentView 的 sizeThatFits 方法，返回正确的 size
        validContentView.sizeToFit()
        containerView.addSubview(validContentView)

        if marqueeDirection == .reverse {
            containerView.frame = CGRect(x: 0, y: 0, width: validContentView.bounds.size.width, height: self.bounds.size.height)
        } else {
            containerView.frame = CGRect(x: 0, y: 0, width: validContentView.bounds.size.width * 2 + contentMargin, height: self.bounds.size.height)
        }

        if validContentView.bounds.size.width > self.bounds.size.width {
            validContentView.frame = CGRect(x: 0, y: 0, width: validContentView.bounds.size.width, height: self.bounds.size.height)
            if marqueeDirection != .reverse {
                let copyContentView = validContentView.copyMarqueeView()
                copyContentView.frame = CGRect(x: validContentView.bounds.size.width + contentMargin, y: 0, width: validContentView.bounds.size.width, height: self.bounds.size.height)
                containerView.addSubview(copyContentView)
            }

            if self.bounds.size.width != 0 {
                startMarquee()
            }
        } else {
            if contentViewFrameConfigWhenCantMarquee != nil {
                contentViewFrameConfigWhenCantMarquee?(validContentView)
            } else {
                validContentView.frame = CGRect(x: 0, y: 0, width: validContentView.bounds.size.width, height: self.bounds.size.height)
            }
        }
    }

    // 如果你的 contentView 的内容在初始化的时候，无法确定。需要通过网络等延迟获取，那么在内容赋值之后，在调用该方法即可。
    public func reloadData() {
        self.setNeedsLayout()
    }

    private func startMarquee() {
        stopMarquee()

        if marqueeDirection == .right {
            var frame = containerView.frame
            frame.origin.x = bounds.size.width - frame.size.width
            containerView.frame = frame
        }

        marqueeDisplayLink = CADisplayLink.init(target: self, selector: #selector(processMarquee))
        marqueeDisplayLink?.preferredFramesPerSecond = self.preferredFramesPerSecond
        marqueeDisplayLink?.add(to: RunLoop.main, forMode: .common)
    }

    private func stopMarquee() {
        marqueeDisplayLink?.invalidate()
        marqueeDisplayLink = nil
    }

    @objc private func processMarquee() {
        var frame = containerView.frame

        switch marqueeDirection {
            case .left:
                let targetX = -(self.contentView!.bounds.size.width + self.contentMargin)
                if frame.origin.x <= targetX {
                    frame.origin.x = 0
                    self.containerView.frame = frame
                } else {
                    frame.origin.x -= pointsPerFrame
                    if frame.origin.x < targetX {
                        frame.origin.x = targetX
                    }
                    self.containerView.frame = frame
                }
            case .right:
                let targetX = self.bounds.size.width - self.contentView!.bounds.size.width
                if frame.origin.x >= targetX {
                    frame.origin.x = self.bounds.size.width - self.containerView.bounds.size.width
                    self.containerView.frame = frame
                } else {
                    frame.origin.x += pointsPerFrame
                    if frame.origin.x > targetX {
                        frame.origin.x = targetX
                    }
                    self.containerView.frame = frame
                }
            case .reverse:
                if isReversing {
                    let targetX: CGFloat = 0
                    if frame.origin.x > targetX {
                        frame.origin.x = 0
                        self.containerView.frame = frame
                        isReversing = false
                    } else {
                        frame.origin.x += pointsPerFrame
                        if frame.origin.x > 0 {
                            frame.origin.x = 0
                            isReversing = false
                        }
                        self.containerView.frame = frame
                    }
                } else {
                    let targetX = self.bounds.size.width - self.containerView.bounds.size.width
                    if frame.origin.x <= targetX {
                        isReversing = true
                    } else {
                        frame.origin.x -= pointsPerFrame
                        if frame.origin.x < targetX {
                            frame.origin.x = targetX
                            isReversing = true
                        }
                        self.containerView.frame = frame
                    }
                }
        }
    }
}
