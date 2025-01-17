//
//  CustomControlViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/15.
//

import UIKit

class CustomControlViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet private weak var schedulePicker: SchedulePicker!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        // 日期选择器
        setupSchedulePicker()

        // 下载按钮
        setupDownloadButton()

        // 购物车按钮
        setupFastCartButton()

        // 双端滑块
        setupRangeSlider()
    }

    // MARK: - 日期选择器

    private func setupSchedulePicker() {
        // Fetch Stored Value
        let scheduleRawValue = UserDefaults.standard.integer(forKey: UserDefaults.Keys.schedule)

        // Configure Schedule Picker
        schedulePicker.schedule = Schedule(rawValue: scheduleRawValue)
    }

    @IBAction func scheduleDidChange(_ sender: SchedulePicker) {
        // Helpers
        let userDefaults = UserDefaults.standard

        // Store Value
        let scheduleRawValue = sender.schedule.rawValue
        printLog("将位掩码保存到 UserDefaults: \(scheduleRawValue)")
        userDefaults.set(scheduleRawValue, forKey: UserDefaults.Keys.schedule)
        userDefaults.synchronize()
    }

    // MARK: - 下载按钮

    let cpl = CircularProgressLayer(frame: CGRect(x: 10, y: 200, width: 100, height: 100))
    let downloadButton = DownloadButton(frame: CGRect(x: 10, y: 350, width: 32, height: 32))

    private func setupDownloadButton() {
        view.addSubview(downloadButton)
        view.layer.addSublayer(cpl)

        tick()
    }

    // 模拟下载进度
    private func tick() {
        guard cpl.progress <= 1.0 else {
            return
        }

        cpl.progress += 0.18
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 0.1)
            self.tick()
        }
    }

    // MARK: - 购物车按钮

    let fastCartButton = FastCartButton()

    private func setupFastCartButton() {
        fastCartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fastCartButton)
        NSLayoutConstraint.activate([
            fastCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fastCartButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fastCartButton.widthAnchor.constraint(equalToConstant: 52),
            fastCartButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    // MARK: - 双端滑块

    let rangeSlider = RangeSlider(frame: .zero)

    private func setupRangeSlider() {
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(rangeSlider)

        NSLayoutConstraint.activate([
            rangeSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rangeSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rangeSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            rangeSlider.heightAnchor.constraint(equalToConstant: 30)
        ])

        // 3 秒后更新滑块样式
        let time = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangeSlider.trackHighlightTintColor = .red
            self.rangeSlider.thumbImage = UIImage.rectNormal
            self.rangeSlider.highlightedThumbImage = UIImage.rectHighlighted
        }
    }

    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        let values = "(\(rangeSlider.lowerValue) \(rangeSlider.upperValue))"
        printLog("Range slider value changed: \(values)")
    }
}

private extension UserDefaults {
    enum Keys {
        static let schedule = "schedule"
    }
}
