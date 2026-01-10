//
//  FoxRightTriangleView.swift
//  FoxEssProject
//
//  Created by huqilin on 2026/1/5.
//

import UIKit

final class FoxRightTriangleView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        
        shapeLayer.fillColor = UIColor(red: 227.0/255.0, green: 231.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.width
        let h = bounds.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: w, y: 0)) // 右上（直角）
        path.addLine(to: CGPoint(x: w, y: h)) // 右下
        path.addLine(to: CGPoint(x: 0, y: 0)) // 左上
        path.close()
        
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
    }
}
