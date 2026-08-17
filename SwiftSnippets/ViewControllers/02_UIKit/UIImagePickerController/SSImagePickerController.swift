//
//  SSImagePickerController.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/8/17.
//

import UIKit
import SnapKit

/// 照片选择器
///
/// reference: <https://vikramios.medium.com/uiimagepickercontroller-in-swift-fc9f05325a9c>
final class SSImagePickerController: UIViewController {
    // MARK: - Controls
    private var imageView: UIImageView!
    private var uploadButton: UIButton!
    
    // MARK: - Properties
    let imagePicker = SSImagePicker()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setupView()
    }
    
    // MARK: - Action
    private func uploadButtonTappedAction() {
        imagePicker.showImagePicker(from: self, allowsEditing: false)
    }
}

// MARK: - Private
extension SSImagePickerController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        // imageView
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.masksToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        // uploadButton
        var config = UIButton.Configuration.plain()
        config.title = "Upload"
        config.titleAlignment = .center
        config.baseForegroundColor = UIColor.systemBlue
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 7, bottom: 6, trailing: 7)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoint = incoming
            outgoint.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            return outgoint
        })
        uploadButton = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.uploadButtonTappedAction()
        })
        // 当文件正在上传中，禁用 “Upload” 按钮
        uploadButton.configurationUpdateHandler = { button in
            switch button.state {
                case .disabled:
                    button.configuration?.baseForegroundColor = UIColor.systemGray
                default:
                    button.configuration?.baseForegroundColor = UIColor.systemBlue
            }
        }
        uploadButton.setContentHuggingPriority(.required, for: .horizontal)
        uploadButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - SSImagePickerDelegate
extension SSImagePickerController: SSImagePickerDelegate {
    func imagePicker(_ imagePicker: SSImagePicker, didSelect image: UIImage) {
        // Handle the selected image
        // You can display, upload, or process the image as needed
        imageView.image = image
    }
    
    func cancelButtonDidClick(on imagePicker: SSImagePicker) {
        printLog("Image selection/capture was canceled")
    }
}
