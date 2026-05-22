//
//  SSAnalysisOverviewViewController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/5/20.
//

import UIKit
import SwiftyJSON

/// Analysis - Overview
final class SSAnalysisOverviewViewController: UIViewController {
    // MARK: - Controls
    private let stackController = FoxScrollStackViewController()
    private var stackView: FoxScrollStack {
        return stackController.scrollStack
    }

    private lazy var summaryViewController: SSAnalysisSummaryCardViewController = {
        let summaryVC = SSAnalysisSummaryCardViewController()
        summaryVC.delegate = self
        return summaryVC
    }()

    // MARK: - Properties
    private var analysisSummaryData: [SSAnalysisSummaryData] = [] {
        didSet {
            performUpdateSummaryCardUI()
        }
    }

    // MARK: - View Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchPlantAnalysisSummaryData()
    }

    // 模拟发起网络请求，获取 JSON 数据
    private func fetchPlantAnalysisSummaryData() {
        DispatchQueue.main.asyncAfter(delay: 3.0) {
            // 解析 JSON 字符串
            let jsonString = """
            [
                {"key":"solar", "value": "6,31", "unit": "kWh", "noMeterFlag": false},
                {"key":"load", "value": "16.22", "unit": "kWh", "noMeterFlag": false},
                {"key":"charge", "value": "8.32", "unit": "kWh", "noMeterFlag": false},
                {"key":"discharge", "value": "16.22", "unit": "kWh", "noMeterFlag": false},
                {"key":"import", "value": "5.98", "unit": "kWh", "noMeterFlag": true},
                {"key":"export", "value": "3.65", "unit": "kWh", "noMeterFlag": false},
                {"key":"aux", "value": "4.5", "unit": "kWh", "noMeterFlag": false},
                {"key":"diesel", "value": "1.2", "unit": "kWh", "noMeterFlag": false}
            ]
            """

            if let data = jsonString.data(using: .utf8) {
                let json = JSON(data)
                self.analysisSummaryData = json.arrayValue.map { SSAnalysisSummaryData(json: $0) }
            }
        }
    }

    private func performUpdateSummaryCardUI() {
        guard let summaryRowIndex = stackView.rowForController(summaryViewController)?.index else {
            return
        }

        if analysisSummaryData.isEmpty {
            stackView.setRowHidden(index: summaryRowIndex, isHidden: true, animated: true)
        } else {
            summaryViewController.analysisSummaryDataArray = analysisSummaryData
            stackView.setRowHidden(index: summaryRowIndex, isHidden: false, animated: true)
        }
    }
}

// MARK: - Private
extension SSAnalysisOverviewViewController {
    private func setupView() {
        title = "Analysis"
        view.backgroundColor = .systemBackground

        stackView.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        stackView.addRow(controller: summaryViewController)
        stackView.rowInsets = .init(top: 16, left: 16, bottom: 0, right: 16)
        stackView.hideSeparators = false
    }
}

// MARK: - SSAnalysisSummaryCardViewDelegate
extension SSAnalysisOverviewViewController: SSAnalysisSummaryCardViewDelegate {
    func analysisSummaryCardViewController(_ controller: SSAnalysisSummaryCardViewController, didSelect item: SSAnalysisSummaryData) {
        let energyType = item.energyType
        printLog(energyType.displayName)
    }

    func analysisSummaryCardViewController(_ controller: SSAnalysisSummaryCardViewController, didTapNoMeter item: SSAnalysisSummaryData) {
    }
}
