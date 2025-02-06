//
//  CustomTableViewCell.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/2/5.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .left
        return label
    }()

    var item: ViewModelItem? {
        didSet {
            guard let item else {
                return
            }

            titleLabel.text = item.title
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    // 使用代码方式构建 cell 时，在这里进行自定义
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // update UI
        accessoryType = selected ? .checkmark : .none
    }
}
