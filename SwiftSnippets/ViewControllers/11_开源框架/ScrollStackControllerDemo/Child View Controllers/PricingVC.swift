//
//  PricingVC.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/12/11.
//

import UIKit

public struct PricingTag {
    public let title: String
    public let subtitle: String
    public let price: String

    public init(title: String, subtitle: String, price: String) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
    }
}

public protocol PricingVCProtocol: AnyObject {
    func addFee()
}

class PricingVC: UIViewController {
    // MARK: - Controls
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var addFreeButton: UIButton!
    private var tableView: UITableView!

    weak var delegate: PricingVCProtocol?

    private var pricingTableHeightConstraint: NSLayoutConstraint!


    public var pricingTags: [PricingTag] = [
        PricingTag(title: "Night fee", subtitle: "$750 x 3 nights", price: "$2,250.00"),
        PricingTag(title: "Hospitality fees", subtitle: "This fee covers services that come with the room", price: "$10.00"),
        PricingTag(title: "Property use taxes", subtitle: "Taxes the cost pays to rent their room", price: "$200.00")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .natural
        titleLabel.textColor = UIColor.label
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "Princing Details"
        view.addSubview(titleLabel)

        // subTitleLabel
        subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.textAlignment = .natural
        subTitleLabel.textColor = UIColor.secondaryLabel
        subTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subTitleLabel.text = "Growing UIViewController with UITableView"
        view.addSubview(subTitleLabel)

        // addFreeButton
        addFreeButton = UIButton(type: .custom)
        addFreeButton.translatesAutoresizingMaskIntoConstraints = false
        addFreeButton.setImage(UIImage(systemName: "plus.app"), for: .normal)
        addFreeButton.addTarget(self, action: #selector(addFreeButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(addFreeButton)

        // tableView
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 67.0

        tableView.register(PricingCell.self, forCellReuseIdentifier: PricingCell.reuseIdentifier)
        tableView.dataSource = self
        view.addSubview(tableView)

        pricingTableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 201) // 67*3

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addFreeButton.centerYAnchor.constraint(equalTo: subTitleLabel.centerYAnchor),
            addFreeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pricingTableHeightConstraint
        ])

        tableView.reloadData()
        tableView.sizeToFit() // !!!: 重要
    }

    public func addFee(_ otherFee: PricingTag) {
        pricingTags.append(otherFee)
        tableView.reloadData()

        updateViewConstraints()
        viewDidLayoutSubviews()
    }

    @objc private func addFreeButtonDidTapped(_ sender: UIButton) {
        delegate?.addFee()
    }

    override func updateViewConstraints() {
        // the size of the table as the size of its content
        pricingTableHeightConstraint.constant = tableView.contentSize.height
        // cancel any height constraint already in place in the view
        view.height(constant: nil)

        super.updateViewConstraints()
    }
}

extension PricingVC: FoxScrollStackContainableController {
    // 基于 UITableView 内容自适应大小
    func scrollStackRowSizeForAxis(_ axis: NSLayoutConstraint.Axis, row: FoxScrollStackRow, in stackView: FoxScrollStack) -> FoxScrollStack.ControllerSize? {
        return .fitLayoutForAxis
//        let size = CGSize(width: stackView.bounds.size.width, height: 9000)
//        let best = self.view.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
//        // NOTE:
//        // it's important to set both the height constraint and bottom safe constraints to safe area for tableview,
//        // otherwise growing does not work.
//        return best.height
    }

    func reloadContentFormStackView(stackView: FoxScrollStack, row: FoxScrollStackRow, animated: Bool) {
        printLog("PricingVC - reloadContentFormStackView")
    }
}

extension PricingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pricingTags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PricingCell.reuseIdentifier) as? PricingCell else {
            fatalError("Unable to Dequeue Cell: 'GalleryCell'")
        }
        cell.priceTag = pricingTags[indexPath.row]
        return cell
    }
}
