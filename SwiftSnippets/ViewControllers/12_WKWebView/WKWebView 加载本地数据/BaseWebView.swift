//
//  BaseWebView.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/8/15.
//

import UIKit
import WebKit

class BaseWebView: UIView {
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        // 开启 Safari 调试功能
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
    }()

    var chartBackgroundColor: UIColor = .white {
        didSet {
            webView.backgroundColor = chartBackgroundColor
        }
    }

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor

        addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Public

    /// 加载本地 html 文件
    func loadLocalContent(_ localFileName: String) {
        if let url = Bundle.main.url(forResource: localFileName, withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }

    /// 注入 JavaScript 脚本
    func injectingJavaScriptString(_ javaScriptString: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }

            webView.evaluateJavaScript(javaScriptString) { _, error in
                if let error {
                    printLog("注入 JavaScript 脚本 发生错误：\(String(describing: error.localizedDescription))")
                }
            }
        }
    }

    // MARK: - Private

    /// 清理 WKWebView 所有缓存
    private func clearCache() {
        let dataStore = WKWebsiteDataStore.default()

        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateFrom = Date(timeIntervalSince1970: 0) // 从时间戳 0 开始删除所有数据

        dataStore.removeData(ofTypes: dataTypes, modifiedSince: dateFrom) {
            // 清理完成后重新加载
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.webView.reload()
            }
        }
    }
}

extension BaseWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        printLog("web视图加载内容时发生错误:\(error)")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        printLog("web视图导航发生错误:\(error)")
    }
}
