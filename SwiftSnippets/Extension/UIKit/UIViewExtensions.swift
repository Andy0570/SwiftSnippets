//
//  UIViewExtensions.swift
//  SeaTao
//
//  Created by Qilin Hu on 2022/9/9.
//

import UIKit

extension UIView {
    /// 为 UIView 添加边框样式
    func applyDashedBorder(color: UIColor, width: CGFloat = 2.0, cornerRadius: CGFloat = 0) {
        let shapeLayer = CAShapeLayer()
        let size = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        // 虚线模式，第一个数字是实线长度，第二个数字是空白长度
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
    }

    /// 模拟按钮点击缩放动画，动画完成后执行 completion() 闭包
    func animateClick(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in
                completion()
            }
        }
    }
}

// MARK: - PDF

extension UIView {
    /// Export pdf from Save pdf in drectory and return pdf file path
    ///
    ///     let pdfFilePath = self.view.exportAsPdfFromView()
    ///     print(pdfFilePath)
    ///
    /// - SeeAlso: <https://www.swiftdevcenter.com/create-pdf-from-uiview-wkwebview-and-uitableview/>
    func exportAsPdfFromView() -> String {
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            return ""
        }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
    }

    /// Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
