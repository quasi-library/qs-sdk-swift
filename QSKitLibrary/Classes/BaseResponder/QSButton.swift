//
//  QSButton.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/30.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit

open class QSButton: UIButton {
    // MARK: - Init Method
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isEnabled = true
        self.layer.masksToBounds = true
        self.titleLabel?.minimumScaleFactor = 0.618
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }

    /// 创建一个纯图片的按钮
    public convenience init(
        normalImageName: String,
        selectedImageName: String? = nil
    ) {
        self.init(type: .custom)

        self.setImage(UIImage(named: normalImageName), for: .normal)
        if let imageName = selectedImageName, let selectedImage = UIImage(named: imageName) {
            self.setImage(selectedImage, for: .selected)
        }
    }

    /// 创建一个单色图片的按钮，(在不同状态下展示不同颜色)
    public convenience init(
        commonImageName: String,
        normalColor: UIColor,
        selectedColor: UIColor,
        disabledColor: UIColor
    ) {
        self.init(type: .custom)

        guard let commonImage = UIImage(named: commonImageName) else {
            return
        }

        // 准备选中状态和非选中状态的图片
        if #available(iOS 13.0, *) {
            let normalImage = commonImage.withTintColor(normalColor)
            let selectedImage = commonImage.withTintColor(selectedColor)
            let disabledImage = commonImage.withTintColor(disabledColor)
            self.setImage(normalImage, for: .normal)
            self.setImage(selectedImage, for: .selected)
            self.setImage(disabledImage, for: .disabled)
        } else {
            // Fallback on earlier versions
            let templateImage = commonImage.withRenderingMode(.alwaysTemplate)
            self.tintColor = normalColor
            self.setImage(templateImage, for: .normal)
        }
    }

    /// 创建一个纯文本的按钮
    public convenience init(
        design: QSStandardDesignStyle,
        title: String? = "button",
        selectedTitle: String? = nil,
        disabledTitle: String? = nil,
        color: UIColor? = nil
    ) {
        self.init(type: .custom)

        let model = VSStandardDesign.standardStyleModel(design)
        self.titleLabel?.font = model.standardFont
        self.setTitle(title, for: .normal)
        self.setTitle(selectedTitle ?? title, for: .selected)
        self.setTitle(disabledTitle ?? title, for: .disabled)
        if let color {
            self.setTitleColor(color, for: .normal)
        } else {
            self.setTitleColor(model.standardColor, for: .normal)
        }
    }

    // MARK: - Public Set Method
    /// 设置实心样式(默认是绿底白字)
    /// - Parameters:
    ///   - backgroundColor: 背景颜色
    ///   - textColor: 标题颜色
    ///   - cornerRadius: 圆角半径
    public func setSolidBoardStyle(
        normal: (backgroundColor: UIColor, textColor: UIColor) = (.appMainGreen, .appMainWhite),
        selected: (backgroundColor: UIColor, textColor: UIColor) = (.appMainRed, .appMainWhite),
        disabled: (backgroundColor: UIColor, textColor: UIColor) = (.lineF4, .lineCC),
        cornerRadius: Double = 2.0,
        contentPadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    ) {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setTitleColor(normal.textColor, for: .normal)
        self.setTitleColor(selected.textColor, for: .selected)
        self.setTitleColor(disabled.textColor, for: .disabled)
        self.setBackgroundImage(UIImage.init(color: normal.backgroundColor), for: .normal)
        self.setBackgroundImage(UIImage.init(color: selected.backgroundColor), for: .selected)
        self.setBackgroundImage(UIImage.init(color: disabled.backgroundColor), for: .disabled)
        self.contentEdgeInsets = contentPadding
    }

    /// 设置空心样式（包边和标题同色）
    /// - Parameter textColor: 标题颜色
    public func setHollowBoardStyle(
        textColor: UIColor = .textMainBlack,
        containerColor: UIColor = .appMainClear,
        borderWidth: CGFloat = 1,
        contentPadding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    ) {
        self.backgroundColor = containerColor
        self.setTitleColor(textColor, for: .normal)
        self.setTitleColor(textColor, for: .selected)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = textColor.cgColor
        self.layer.cornerRadius = borderWidth / 2
        self.setBackgroundImage(nil, for: .normal)
        self.setBackgroundImage(nil, for: .selected)
        self.contentEdgeInsets = contentPadding
    }

    // MARK: - UI Layout Method
    /// 添加内边距后更新实际大小
    open override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let contentInsets = contentEdgeInsets
        let width = originalSize.width + contentInsets.left + contentInsets.right
        let height = originalSize.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}
