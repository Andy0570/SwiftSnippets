//
//  LoadingView.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/7/7.
//

import UIKit

final class LoadingView: UIView {
    private var indicatorView: UIActivityIndicatorView!

    // 便利构造器，它不接受任何参数
    convenience init() {
        // 委托给内部的指定构造器
        self.init(frame: .zero)
    }

    // 覆写父类的指定构造器
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func makeUI() {
        // indicatorView
        indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            indicatorView.style = UIActivityIndicatorView.Style.medium
        } else {
            indicatorView.style = UIActivityIndicatorView.Style.gray
        }
        indicatorView.startAnimating()
        addSubview(indicatorView)

        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
