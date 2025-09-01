//
//  WebViewTestController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/8/15.
//

import UIKit

class WebViewTestController: UIViewController {
    // loading remote content
    @IBAction func testLoadRemoteUrlButtonTapped(_ sender: Any) {
        let testUrl1 = "https://www.baidu.com"
        let testUrl2 = "https://sspai.com/"

        let baseWebView = BaseWebViewController(requestUrl: testUrl1)
        navigationController?.pushViewController(baseWebView, animated: true)
    }
}
