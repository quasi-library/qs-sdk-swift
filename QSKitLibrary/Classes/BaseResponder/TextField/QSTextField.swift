//
//  VSTextField.swift
//  QuasiDemo
//
//  Created by Soul on 2022/12/8.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit

class QSTextField: UITextField {
    // MARK: - Property
    /// 内边距，也就是padding
    var contentInset: UIEdgeInsets = .zero

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Init Method
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.tintColor = .appMainGreen
    }

    // MARK: - UI Layout Method
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        // 根据edgeInsets，修改placeholder文字的bounds
        let rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset))
        return rect
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset))
        // 根据edgeInsets，修改绘制文字的bounds
        rect.origin.y -= contentInset.top
        rect.size.height += contentInset.top + contentInset.bottom
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset))
        // 根据edgeInsets，修改正在编辑的文字的bounds
        rect.origin.y -= contentInset.top
        rect.size.height += contentInset.top + contentInset.bottom
        return rect
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        let x = rect.origin.x + contentInset.left
        return CGRect(
            x: x,
            y: rect.origin.y,
            width: rect.width,
            height: rect.height
        )
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        let x = rect.origin.x - contentInset.right
        return CGRect(
            x: x,
            y: rect.origin.y,
            width: rect.width,
            height: rect.height
        )
    }

//    open override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: contentInset))
//    }
}
