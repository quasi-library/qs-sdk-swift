//
//  UIImage+Extension.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2022/1/10.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit
import Foundation

public extension UIImage {
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }

    // 圆角图片
    var rounded: UIImage {
        let scale = UIScreen.main.scale
        let radius = min(size.width, size.height) / 2
        let rect = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        let diff = size.width - size.height
        if diff > 0 {
            draw(at: CGPoint(x: -diff / 2, y: 0))
        } else {
            draw(at: CGPoint(x: 0, y: -diff / 2))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    // 重定义宽度
    func resize(_ maxWidth: CGFloat) -> UIImage {
        let ratio = size.width / size.height
        let rect = ratio >= 1 ? CGRect(x: 0, y: 0, width: maxWidth, height: maxWidth / ratio) : CGRect(x: 0, y: 0, width: maxWidth * ratio, height: maxWidth)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        let thumb = UIGraphicsGetImageFromCurrentImageContext()!
        return thumb
    }

    // 将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        // 计算最终尺寸
        var newSize: CGSize
        if size.width / size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        } else {
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }

        //// 图片绘制区域
        var rect = CGRect.zero
        rect.size.width = size.width
        rect.size.height = size.height
        rect.origin.x = (newSize.width - size.width) / 2.0
        rect.origin.y = (newSize.height - size.height) / 2.0

        // 绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage ?? UIImage()
    }

    func imageWithTintColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }

    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setAlpha(alpha)
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -size.height)
        ctx?.draw(cgImage!, in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
