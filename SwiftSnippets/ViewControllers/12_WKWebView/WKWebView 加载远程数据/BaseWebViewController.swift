//
//  BaseWebViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/8/15.
//

import UIKit
import WebKit

/// 网页视图
/// 参考：<https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview>
class BaseWebViewController: UIViewController {
    private let requestUrl: String

    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        // 注入 JavaScript 代码，自适应字体
        let scriptSource = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        // 添加数据检测支持
        config.dataDetectorTypes = [.all]

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self

        // 监听 WKWebView 对象的 estimatedProgress 属性，显示加载进度条
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        // 自动根据 Web 页面返回的 title 标题设置导航栏标题
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)

        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .clear // 背景颜色
        progressView.tintColor = .systemBlue // 进度条颜色
        return progressView
    }()

    init(requestUrl: String) {
        self.requestUrl = requestUrl
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: - View Life Cycle

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
    }

    override func loadView() {
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        progressView.setProgress(0.0, animated: true)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)

        if let url = URL(string: requestUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // MARK: - KVO Callback

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let newProgress = webView.estimatedProgress
            if Float(newProgress) > progressView.progress {
                progressView.setProgress(Float(newProgress), animated: true)
            } else {
                progressView.setProgress(Float(newProgress), animated: false)
            }
            if newProgress >= 1 { // delaying so that user can see progress view reach 100%
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.progressView.isHidden = true
                })
            } else {
                progressView.isHidden = false
            }
        } else if keyPath == #keyPath(WKWebView.title) {
            self.navigationItem.title = webView.title
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - WKNavigationDelegate

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 控制可访问的网站，仅允许用户访问 baidu.com 域名下的内容
        if let host = navigationAction.request.url?.host {
            if host.contains("baidu.com") {
                decisionHandler(.allow)
                return
            }
        }

        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("web视图加载内容时发生错误:\(error)")
        MessageCenter.shared.showError(title: "网络加载失败", body: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("web视图导航发生错误:\(error)")
        MessageCenter.shared.showError(title: "网络加载失败", body: error.localizedDescription)
    }
}
