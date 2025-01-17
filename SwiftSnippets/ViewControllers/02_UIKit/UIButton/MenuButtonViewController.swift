//
//  MenuButtonViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/5.
//

import UIKit

/// iOS 15 中的 UIButton 新特性
/// 参考
/// * <https://www.notion.so/andy0570/iOS15-ab0747b1e9f04b0fa6679427340988e1?pvs=4>
class MenuButtonViewController: UIViewController {
    private enum Constants {
        static let margin: CGFloat = 20.0
        static let imagePadding: CGFloat = 5.0
    }

    private var itemCount: Int = 0 {
        didSet {
            checkoutButton.setNeedsUpdateConfiguration()
        }
    }

    private var range = Measurement(value: 100, unit: UnitLength.miles) {
        didSet {
            carButton.setNeedsUpdateConfiguration() // 请求系统更新按钮配置
        }
    }

    private lazy var formatter = MeasurementFormatter()

    // MARK: - Public

    // 点击"我要评论..."按钮，执行的回调闭包
    var didTapCommentPencilButton: (() -> Void)?
    // 点击“发图文”按钮，执行的回调闭包，'@objc' 关键字可以让这个闭包供外部 Objective-C 类调用
    @objc public var didTapPublishImage: (() -> Void)?

    // MARK: - Controls

    // UIButton 弹出菜单（iOS 15特性）
    // 弱引用的隐式解包可选类型变量
    private weak var menuButton: MenuButton!
    private weak var submitButton: UIButton!
    private var publishImageButton: UIButton!

    private let buttonPanelView = ButtonPanelView()
    private let label = UILabel()

    /// 垂直布局的堆栈视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    /// 汽车按钮
    private lazy var carButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .capsule // 按钮圆角样式，胶囊
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .preferredFont(forTextStyle: .headline)
            return outgoing
        })

        // 设置按钮尾部汽车图片
        config.image = UIImage(systemName: "car", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.imagePlacement = .trailing
        config.imagePadding = 8.0

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        /**
         要改变按钮的外观以响应状态的变化，需要注册一个配置更新处理程序。

         UIButton.ConfigurationUpdateHandler 是一个用来更新按钮配置的闭包：
         typealias ConfigurationUpdateHandler = (UIButton) -> Void
         配置处理程序中设置的任何值都将优先于闭包外部设置的任何值。
         */
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            // 当显示活动指示器时，会替换掉原有的图像
            // config?.showsActivityIndicator = true
            config?.image = button.isHighlighted ? UIImage(systemName: "car.fill") : UIImage(systemName: "car")
            config?.subtitle = self.formatter.string(from: self.range)
            button.configuration = config
        }

        button.configuration = config
        button.setTitle("Start", for: .normal)

        // 按钮点击事件：每次点击按钮，随机更新公里数
        button.addAction(
            UIAction { _ in
                self.range = Measurement(value: Double.random(in: 10...1000), unit: UnitLength.miles)
            }, for: .touchUpInside)

        return button
    }()

    /// 「我要评论..」按钮
    private lazy var commentPencilButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let titleColor = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 1.0)

        if #available(iOS 15.0, *) {
            printLog("iOS 15.0 以上系统，使用 configuration 语法配置按钮样式")

            var config = UIButton.Configuration.gray()
            config.baseForegroundColor = titleColor
            config.buttonSize = .medium
            config.cornerStyle = .capsule

            // 配置按钮标题样式
            var container = AttributeContainer()
            container.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            // !!!: 在 UIKit 代码中配置下划线样式需要加 '.uikit'
            container.uiKit.underlineStyle = .single
            container.uiKit.underlineColor = titleColor
            config.attributedTitle = AttributedString("我要评论...", attributes: container)
            config.titleAlignment = .leading

            // iOS 13.0, 配置 SF 图片
            config.image = UIImage(systemName: "highlighter")
            config.imagePadding = 5.0
            config.imagePlacement = .leading
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 30)

            button.configuration = config

            // iOS 13.0
            let action = UIAction { _ in
                self.didTapCommentPencilButton?()
            }
            button.addAction(action, for: .touchUpInside)
        } else {
            printLog("iOS 15.0 以下系统，降级到旧语法配置按钮样式")

            button.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
            button.setTitle("我要评论...", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(titleColor, for: .normal)
            button.layer.cornerRadius = 17.0
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(commentPencilButtonTapped(_:)), for: .touchUpInside)
        }

        return button
    }()

    private lazy var checkoutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemPink
        configuration.buttonSize = .large

        return UIButton(configuration: configuration, primaryAction: nil)
    }()

    // 视频详情页，更多按钮...
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        // !!!: 默认图片是黑白色的，这里需要将 tint 值渲染成你想要的颜色
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(named: "navBar_more")?.withTintColor(UIColor.systemPink), for: .normal)
        } else {
            button.setImage(UIImage(named: "navBar_more")?.tint(UIColor.systemPink, blendMode: .destinationIn), for: .normal)
        }

        button.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    /************************ tagsButton ************************/
    // 把按钮标签当成普通的文本标签使用
    private(set) lazy var tagsButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("标签名称", for: .normal)

        if #available(iOS 13.0, *) {
            button.backgroundColor = UIColor.tertiarySystemGroupedBackground
        } else {
            button.backgroundColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
        }

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2

        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        // 标题向右移动 4pt
        // button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)

        button.isUserInteractionEnabled = false
        return button
    }()

    /************************ 移出黑名单 ************************/
    private(set) lazy var removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        button.setTitle("移出黑名单", for: .normal)
        button.setTitleColor(UIColor(hexString: "#53CAC3"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.layer.cornerRadius = 2.0
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(hexString: "#53CAC3")?.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        // 自定义的 outline 按钮
        setupCustomOutlineButton()

        // 移出黑名单，旧方法创建的 outlien 样式按钮，没有点击特效
        setupRemoveButton()

        // 弹出菜单
        setupMenuButton()

        // 汽车
        setupCarButton()

        // 我要评论
        setupCommentButton()

        // 电商应用按钮示例，在结账按钮中显示购买商品总数
        setupCheckoutButton()

        // 圆角按钮
        setupRoundedCornersButton()

        // 提交按钮
        setupSubmitButton()

        // 更多按钮
        setupMoreButton()

        // 把按钮标签当成普通的文本标签使用
        setupTagsButton()

        // 发图文、发视频
        setupPublishImageButton()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap!"
        label.sizeToFit()
        view.addSubview(label)
        buttonPanelView.delegate = self
        view.addSubview(buttonPanelView)
        NSLayoutConstraint.activate([
            buttonPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonPanelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),

            label.topAnchor.constraint(equalTo: buttonPanelView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: buttonPanelView.centerXAnchor)
        ])
    }

    private func setupCustomOutlineButton() {
        var configuration = UIButton.Configuration.filled()

        configuration.title = "Normal"
        let normal = OutlineButton(configuration: configuration, primaryAction: nil)

        configuration.title = "Highlighted"
        let highlighted = OutlineButton(configuration: configuration, primaryAction: nil)
        highlighted.isHighlighted = true

        configuration.title = "Selected"
        let selected = OutlineButton(configuration: configuration, primaryAction: nil)
        selected.isSelected = true

        configuration.title = "Highlighted Selected"
        let highlightedSelected = OutlineButton(configuration: configuration, primaryAction: nil)
        highlightedSelected.isHighlighted = true
        highlightedSelected.isSelected = true

        configuration.title = "Disabled"
        let disabled = OutlineButton(configuration: configuration, primaryAction: nil)
        disabled.isEnabled = false

        stackView.addArrangedSubviews([normal, highlighted, selected, highlightedSelected, disabled])
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor)
        ])
    }

    private func setupRemoveButton() {
        view.addSubview(removeButton)
        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            removeButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
    }

    private func setupMenuButton() {
        let button = MenuButton()
        view.addSubview(button)
        menuButton = button
        NSLayoutConstraint.activate(button.layoutConstraints(in: view))
    }

    private func setupCarButton() {
        view.addSubview(carButton)
        NSLayoutConstraint.activate([
            carButton.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 10),
            carButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setupCommentButton() {
        view.addSubview(commentPencilButton)
        NSLayoutConstraint.activate([
            commentPencilButton.topAnchor.constraint(equalTo: carButton.bottomAnchor, constant: 20),
            commentPencilButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setupCheckoutButton() {
        // 添加按钮，模拟添加商品
        let addButton = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [unowned self] _ in
            itemCount += 1
        }))
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add Item", for: .normal)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: commentPencilButton.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        // checkout 结账按钮
        checkoutButton.configurationUpdateHandler = { [unowned self] button in
            button.configuration?.title = "Checkout \(itemCount)"
        }
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkoutButton)
        NSLayoutConstraint.activate([
            checkoutButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    // 创建圆角按钮
    // 参考：<https://sarunw.com/posts/uikit-rounded-corners-button/>
    private func setupRoundedCornersButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "圆角按钮"
        // 设置按钮的背景色
        configuration.baseBackgroundColor = UIColor.systemPink
        // 设置按钮和标题周围的填充
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        /**
        1. 使用预定义的 cornerStyle 控制圆角半径

        configuration.cornerStyle = .small
        configuration.cornerStyle = .medium
        configuration.cornerStyle = .large
        configuration.cornerStyle = .capsule
         */
        // configuration.cornerStyle = .large

        /**
         2. 自定义圆角半径
         */
        configuration.background.cornerRadius = 20
        configuration.cornerStyle = .fixed

        let roundedCornersButton = UIButton(configuration: configuration)
        roundedCornersButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roundedCornersButton)
        NSLayoutConstraint.activate([
            roundedCornersButton.topAnchor.constraint(equalTo: checkoutButton.bottomAnchor, constant: 10),
            roundedCornersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setupSubmitButton() {
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("提交", for: .normal)
        submit.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submit)
        submitButton = submit

        NSLayoutConstraint.activate([
            submit.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            submit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    private func setupMoreButton() {
        view.addSubview(moreButton)

        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10),
            moreButton.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 36),
            moreButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupTagsButton() {
        view.addSubview(tagsButton)

        NSLayoutConstraint.activate([
            tagsButton.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 10),
            tagsButton.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor)
        ])
    }

    private func setupPublishImageButton() {
        let imageBtnColor = UIColor(red: 84 / 255.0, green: 234 / 255.0, blue: 222 / 255.0, alpha: 1.0)
        publishImageButton = makePublishButton(title: "发图文", systenImageName: "photo", backgroundColor: imageBtnColor)
        publishImageButton.addTarget(self, action: #selector(publishImageTapped), for: .touchUpInside)
        view.addSubview(publishImageButton)

        NSLayoutConstraint.activate([
            publishImageButton.topAnchor.constraint(equalTo: tagsButton.bottomAnchor, constant: 10),
            publishImageButton.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            publishImageButton.widthAnchor.constraint(equalToConstant: 200),
            publishImageButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // 通过工厂方法创建按钮
    private func makePublishButton(title: String, systenImageName: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = backgroundColor
            config.baseForegroundColor = UIColor.black
            config.buttonSize = .large
            config.cornerStyle = .capsule

            // 配置按钮标题样式
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                var outgoing = incoming
                outgoing.font = UIFont.preferredFont(forTextStyle: .body)
                return outgoing
            })

            // 配置 SF 图片
            config.image = UIImage(systemName: systenImageName)
            config.imagePadding = Constants.imagePadding
            config.imagePlacement = .trailing
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            button.configuration = config
        } else {
            button.backgroundColor = backgroundColor
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            button.layer.cornerRadius = 25.0
            button.layer.masksToBounds = true
        }

        button.setTitle(title, for: .normal)
        return button
    }

    // MARK: - Actions

    // @objc 的作用仅是将 Swift 函数暴露给 Objective-C 调用
    // 由于许多框架仍然使用 Objective-C 编写，即使我们使用 Swift 与它们交互。
    // 因此需要使用 @objc 标注，将该方法暴露给 Objective-C 运行时。
    @objc private func commentPencilButtonTapped(_ sender: UIButton) {
        printLog(#"点击了"我要评论"按钮"#)
        self.didTapCommentPencilButton?()
    }

    @objc func submitButtonTapped(_ sender: UIButton) {
        printLog("点击了提交按钮，验证表单，发送网络请求...")
    }

    @objc func moreButtonTapped(_ sender: UIButton) {
        printLog("点击了更多按钮，显示分享弹窗...")
    }

    @objc func publishImageTapped(_ sender: UIButton) {
        printLog("点击了发图文按钮，打开新的表单页面...")
        self.didTapPublishImage?()
    }
}

// MARK: - ButtonPanelDelegate

extension MenuButtonViewController: ButtonPanelDelegate {
    func didTapButtonWithText(_ text: String) {
        guard text != label.text else {
            return
        }

        label.text = text
    }
}
