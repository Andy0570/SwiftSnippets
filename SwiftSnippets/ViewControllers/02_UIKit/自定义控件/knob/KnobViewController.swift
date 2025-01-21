//
//  KnobViewController.swift
//  SwiftSnippets
//
//  Created by Qilin Hu on 2025/1/20.
//

import UIKit

/// 可重复使用的旋钮
/// 参考：<https://www.kodeco.com/5294-how-to-make-a-custom-control-tutorial-a-reusable-knob>
class KnobViewController: UIViewController {
    // MARK: - Properties

    private lazy var knob: Knob = {
        let knob = Knob()
        knob.translatesAutoresizingMaskIntoConstraints = false
        knob.lineWidth = 4
        knob.pointerLength = 12
        return knob
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 50.0)
        label.text = "0.00"
        return label
    }()

    private lazy var valueSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        return slider
    }()

    private lazy var animateSwitch: UISwitch = {
        let animateSwitch = UISwitch()
        animateSwitch.translatesAutoresizingMaskIntoConstraints = false
        return animateSwitch
    }()

    private lazy var randomValueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Random Value", for: .normal)
        button.addTarget(self, action: #selector(handleRandomButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var animateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17.0)
        label.text = "animate"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        setupSubview()

        // 将旋钮和文本标签的初始化值更新为 Slider 的初始值
        knob.setValue(valueSlider.value)
        updateLabel()

        knob.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
    }

    // MARK: - Actions

    @objc func handleValueChanged(_ sender: Any) {
        // 将旋钮器的值与 valueSlider 滑动时相匹配
        if sender is UISlider {
            knob.setValue(valueSlider.value)
        } else {
            valueSlider.value = knob.value
        }
        updateLabel()
    }

    @objc func handleRandomButtonPressed(_ button: UIButton) {
        // 生成 0.00 到 1.00 之间的随机值，并在两个控件上设置该值
        let randomValue = Float.random(in: 0.0...1.0)
        knob.setValue(randomValue, animated: animateSwitch.isOn)
        valueSlider.setValue(Float(randomValue), animated: animateSwitch.isOn)
        updateLabel()
    }

    func updateLabel() {
        valueLabel.text = String(format: "%.2f", knob.value)
    }

    // MARK: - Private

    private func setupSubview() {
        view.addSubview(knob)
        view.addSubview(valueLabel)
        view.addSubview(valueSlider)
        view.addSubview(animateSwitch)
        view.addSubview(randomValueButton)
        view.addSubview(animateLabel)

        NSLayoutConstraint.activate([
            knob.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            knob.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            knob.widthAnchor.constraint(equalToConstant: 140),
            knob.heightAnchor.constraint(equalToConstant: 140),

            valueLabel.leadingAnchor.constraint(equalTo: knob.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            valueLabel.bottomAnchor.constraint(equalTo: knob.bottomAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 50),

            valueSlider.topAnchor.constraint(equalTo: knob.bottomAnchor, constant: 8),
            valueSlider.leadingAnchor.constraint(equalTo: knob.leadingAnchor),
            valueSlider.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),

            randomValueButton.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 42),
            randomValueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomValueButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 128),

            animateSwitch.centerYAnchor.constraint(equalTo: randomValueButton.centerYAnchor),
            animateSwitch.leadingAnchor.constraint(equalTo: knob.leadingAnchor),

            animateLabel.leadingAnchor.constraint(equalTo: knob.leadingAnchor),
            animateLabel.topAnchor.constraint(equalTo: animateSwitch.bottomAnchor, constant: 8)
        ])
    }
}
