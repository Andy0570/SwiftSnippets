//
//  WebViewTest2Controller.swift
//  SwiftSnippets
//
//  Created by huqilin on 2025/8/15.
//

import UIKit

class WebViewTest2Controller: UIViewController {
    private var webChartView: BaseWebView!
    private var sendDataButton: UIButton!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()


        setupView()
        setupLayout()
    }

    private func setupView() {
        view.backgroundColor = UIColor.systemBackground

        // webChartView
        webChartView = BaseWebView(frame: .zero)
        webChartView.chartBackgroundColor = UIColor(hex: "0x1F2124")
        webChartView.translatesAutoresizingMaskIntoConstraints = false
        webChartView.loadLocalContent("appBarChart")
        view.addSubview(webChartView)

        // sendDataButton
        sendDataButton = UIButton(type: .system)
        sendDataButton.translatesAutoresizingMaskIntoConstraints = false
        sendDataButton.setTitle("send Data", for: .normal)
        sendDataButton.addTarget(self, action: #selector(sendDataButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(sendDataButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            webChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webChartView.widthAnchor.constraint(equalToConstant: 141),
            webChartView.heightAnchor.constraint(equalToConstant: 90),

            sendDataButton.topAnchor.constraint(equalTo: webChartView.bottomAnchor, constant: 20),
            sendDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Actions

    // 将 JavaScript 内容注入 WebView
    @objc private func sendDataButtonDidTapped(_ button: UIButton) {
        let barData = [
            BarData(index: "27", value: "12.8"),
            BarData(index: "28", value: "12"),
            BarData(index: "29", value: "11"),
            BarData(index: "30", value: "15"),
            BarData(index: "31", value: "30"),
            BarData(index: "1", value: "18"),
            BarData(index: "2", value: "12.8")
        ]
        let productBarData = ProductBarData(color: "#198038", barData: barData)

        // 使用 JSONEncoder 将 Struct 编码为 JSON
        let jsonEncoder = JSONEncoder()
        do {
            let encodedProductBarData = try jsonEncoder.encode(productBarData)
            if let jsonString = String(data: encodedProductBarData, encoding: .utf8) {
                webChartView.injectingJavaScriptString("echartsBarList(\(jsonString))")
            }
        } catch {
            printLog(error.localizedDescription)
        }
    }
}
