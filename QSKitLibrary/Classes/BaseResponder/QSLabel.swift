//
//  QSLabel.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/27.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit

/// 基于UILabel进行的封装,主要实现设计标准化;使用方式采取自定义initWithXxx:方法或者init之后调用vsSetXxx:方法
public class QSLabel: UILabel {
    // MARK: - Property
    /// 内边距，也就是padding
    var contentInset: UIEdgeInsets = .zero

    // MARK: - Init Method
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init() {
        super.init(frame: .zero)
        self.textColor = UIColor.textMainBlack
        self.layer.masksToBounds = true
        self.minimumScaleFactor = 0.618
        self.adjustsFontSizeToFitWidth = true
    }

    /// 通用构造方法
    /// 根据标准化Type统一初始化，并重设颜色及字体大小
    /// - Parameters:
    ///   - type:  标准化设计模版风格
    ///   - title:  标题文字
    ///   - color:  标题颜色
    ///   - fontSize: 标题文字大小(默认传0，使用模板大小，需自定义再传值)
    /// - Returns: VSLabel
    public convenience init(
        style: QSStandardDesignStyle,
        title: String?,
        color: UIColor? = nil,
        fontSize: CGFloat = 0
    ) {
        self.init()

        self.vsSetDesignStyle(
            style,
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

        if fontSize != 0 {
            self.font = UIFont.init(name: self.font.fontName, size: fontSize ?? 12)
        }
    }

    /// 自定义标签圆角和包边
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - color:  包边颜色
    ///   - width: 包边宽度
    open func vsSetCornerRadius(
        _ radius: CGFloat,
        color: UIColor?,
        width: CGFloat?
    ) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width ?? 0
        self.layer.borderColor = color?.cgColor
    }

    ///  设置行间距,展示为富文本,重新布局
    /// - Parameter lineSpacing: 行间距
    open func lb_layoutLineSpacing(_ lineSpacing: CGFloat) {
        if lineSpacing > 0 {
            let attributedString = NSMutableAttributedString.init(string: self.text ?? "")
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = self.textAlignment
            attributedString.setAttributes(
                [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.foregroundColor: self.textColor ?? .textMainBlack,
                    NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 14)
                ],
            range: NSRange.init(location: 0, length: self.text?.count ?? 0))
        }
    }

    // MARK: - UI Layout Method
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect: CGRect = super.textRect(
            forBounds: bounds.inset(by: contentInset),
            limitedToNumberOfLines: numberOfLines
        )
        // 根据edgeInsets，修改绘制文字的bounds
        rect.origin.x -= contentInset.left
        rect.origin.y -= contentInset.top
        rect.size.width += contentInset.left + contentInset.right
        rect.size.height += contentInset.top + contentInset.bottom
        return rect
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
}
