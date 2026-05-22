//
//  SSAnalysisSummaryCardViewCell.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/5/20.
//

import UIKit
import SnapKit

final class SSAnalysisSummaryCardViewCell: UICollectionViewCell {
    // MARK: - Controls
    private var iconImageView: UIImageView!
    private var arrowImageView: UIImageView!
    // -----------------------------------------------
    private var titleLabel: UILabel!
    // -----------------------------------------------
    private var horizontalStackView: UIStackView!
    private var subTitleLabel: UILabel!
    private var noMeterButton: UIButton!

    var didTapNoMeterButton: (() -> Void)?

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)

        applyRoundedCorners()
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
        noMeterButton.isHidden = true
    }

    // MARK: - Public
    func configure(with item: SSAnalysisSummaryData) {
        let energyType = item.energyType

        contentView.backgroundColor = energyType.color
        iconImageView.image = UIImage(named: energyType.imageName)?.withTintColor(UIColor(hex: "#141414"))
        titleLabel.text = energyType.displayName
        subTitleLabel.setAttributedText(
            value: item.value,
            unit: item.unit,
            textColor: UIColor(hex: "#141414"),
            valueFont: .systemFont(ofSize: 20, weight: .bold),
            unitFont: .systemFont(ofSize: 15, weight: .semibold)
        )

        noMeterButton.isHidden = !item.noMeterFlag
        UIView.animate(withDuration: 0.24) {
            self.contentView.layoutIfNeeded()
        }
    }
}

// MARK: - Private
extension SSAnalysisSummaryCardViewCell {
    private func setupView() {
        // iconImageView
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }

        // arrowImageView
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow_right_12x12")?.withTintColor(UIColor.white)
        arrowImageView.contentMode = .scaleAspectFit
        contentView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-8)
            make.centerY.equalTo(iconImageView)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }

        // titleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = .systemFont(ofSize: 13.0, weight: .regular)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .natural
        // 设置宽度优先级，避免文本被压缩
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        // horizontalStackView
        horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 4
        contentView.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }

        // Cell 宽度 = max(titleLabel, horizontalStackView)，且不小于 122
        contentView.snp.makeConstraints { make in
            make.trailing.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(16)
            make.trailing.greaterThanOrEqualTo(horizontalStackView.snp.trailing).offset(16)
            make.width.greaterThanOrEqualTo(122)
        }

        // subTitleLabel
        subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        subTitleLabel.textColor = UIColor.secondaryLabel
        subTitleLabel.textAlignment = .natural
        // 设置宽度优先级，避免文本被压缩
        subTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        horizontalStackView.addArrangedSubview(subTitleLabel)

        // noMeterButton
        var configuration = UIButton.Configuration.filled()
        configuration.title = "No Meter"
        configuration.baseBackgroundColor = UIColor(hex: "#5E2900")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        configuration.background.backgroundColor = UIColor(hex: "#5E2900")
        configuration.background.strokeColor = UIColor(hex: "#FFB784")
        configuration.background.strokeWidth = 1.0
        configuration.background.cornerRadius = 6.0
        configuration.cornerStyle = .fixed
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 13, weight: .semibold)
            return outgoing
        })
        noMeterButton = UIButton(configuration: configuration, primaryAction: UIAction { _ in
                self.didTapNoMeterButton?()
        }
        )
        noMeterButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        horizontalStackView.addArrangedSubview(noMeterButton)
    }
}
