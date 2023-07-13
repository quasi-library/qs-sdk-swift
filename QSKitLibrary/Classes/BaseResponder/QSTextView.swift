//
//  QSTextView.swift
//  QuasiDemo
//
//  Created by Soul on 2023/5/15.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

class QSTextView: UITextView {
    // MARK: - Init Method
    /// 通用构造方法
    convenience init(
        type: QSStandardDesignStyle,
        title: String?,
        color: UIColor? = nil,
        fontSize: CGFloat = 0
    ) {
        self.init()
        self.isEditable = false

        self.vsSetDesignStyle(
            type,
            title: title,
            color: color,
            fontSize: fontSize
        )
    }

    // MARK: - Set Method

    /// 先根据Type设置字体风格,若不满足可再传入自定义颜色及字体
    /// - Parameters:
    ///   - type: 标准化设计模版风格
    ///   - title: 标签标题
    ///   - color: 标题颜色;若不满足模版风格传入自定义颜色,否则传nil
    ///   - fontSize: 标题字体大小;字体类型受Type约束,需要自定义大小传值,否则传0
    open func vsSetDesignStyle(
        _ type: QSStandardDesignStyle,
        title: String?,
        color: UIColor? = nil,
        fontSize: CGFloat? = nil
    ) {
        let model = VSStandardDesign.standardStyleModel(type)
        self.font = model.standardFont
        self.textColor = model.standardColor

        if title?.isBlank == false {
            self.text = title
        }

        if color != nil {
            self.textColor = color
        }

        if let fontSize, fontSize != 0 {
            if let currentFont = self.font {
                self.font = UIFont.init(name: currentFont.fontName, size: fontSize )
            } else {
                self.font = UIFont.systemFont(ofSize: fontSize)
            }
        }
    }
}
