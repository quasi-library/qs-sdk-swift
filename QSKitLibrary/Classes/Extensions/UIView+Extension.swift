//
//  UIView+Extension.swift
//  QuasiDemo
//
//  Created by Geminy on 2021/11/1.
//

import UIKit

extension UIView {
    /// 通过响应者找到view所处的viewController
    @objc func currentVC() -> UIViewController? {
        var n = next
        while n != nil {
            if n is UIViewController {
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }

    /// 添加虚线边框
    func swiftDrawBoardDottedLine(width: CGFloat, lenth: CGFloat, space: CGFloat, cornerRadius: CGFloat, color: UIColor) {
//        if let layers = self.layer.sublayers {
//            for layer in layers {
//                layer.removeFromSuperlayer()
//            }
//        }
        self.layer.cornerRadius = cornerRadius
        let borderLayer = CAShapeLayer()
        borderLayer.bounds = self.bounds

        borderLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = width / UIScreen.main.scale

        // 虚线边框---小边框的长度
        if lenth > 0 || space > 0 {
            borderLayer.lineDashPattern = [lenth, space] as? [NSNumber] // 前边是虚线的长度，后边是虚线之间空隙的长度
            borderLayer.lineDashPhase = 0.1
        }
        // 实线边框

        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.layer.addSublayer(borderLayer)
//        borderLayer.fillColor = UIColor.white.cgColor
//        borderLayer.strokeColor = color.cgColor
//        self.layer.mask = borderLayer

    }
}
