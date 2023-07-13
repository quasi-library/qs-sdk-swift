//
//  VSBottomAlertView.swift
//  QuasiDemo
//
//  Created by Soul on 2023/4/26.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import QSKitLibrary
import SwiftEntryKit

/// 底部升起的弹窗(多为列表)，结合SwiftEntryKit使用
class VSBottomAlertView: UIView {
    // MARK: - Property
    /// 默认展示的标题，供子类覆写
    var alertTitle: String {
        return "Alert"
    }

    // MARK: - Init / Public Method
    /// 点击“关闭”按钮之后的回调
    var closeClickedBlock: (() -> Void)? = {
        debugPrint(VSBottomAlertView.self, "点击close按钮之后的回调")
    }

    /// 通过SwiftEntryKit通用加载方式
    /// 如过修改弹窗属性请在调用前手动更新alertAttributes
    func show() {
        self.alertAttributes.name = self.alertTitle
        SwiftEntryKit.display(entry: self, using: self.alertAttributes)
    }

    /// 通过SwiftEntryKit通用移除方式
    func dismiss() {
        if let entryName = self.alertAttributes.name, entryName.isBlank == false {
            SwiftEntryKit.dismiss(.specific(entryName: entryName))
        } else {
            SwiftEntryKit.dismiss(.displayed)
        }
    }

    // MARK: - Lifecycle Method
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel.text = alertTitle
        addSubSnaps()
        layoutSnaps()
    }

    // MARK: - UI Action Method
    /// 点击关闭按钮(回调给vc关闭弹窗)
    @objc private func clickCloseButtonAction() {
        self.dismiss()
        self.closeClickedBlock?()
    }

    // MARK: - UI Layout Method
    internal func addSubSnaps() {
        self.addSubview(titleArea)
        self.addSubview(titleLine)

        titleArea.addSubview(closeButton)
        titleArea.addSubview(titleLabel)
    }

    internal func layoutSnaps() {
        titleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        titleLine.snp.makeConstraints { make in
            make.top.equalTo(titleArea.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    /// 使用SwiftEntryKit加载时默认动画
    public lazy var alertAttributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes = .bottomFloat
        attributes.displayMode = .inferred
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: EKColor(light: .appBackgroundAlert, dark: .appBackgroundAlert))
        attributes.entryBackground = .color(color: .white)
        attributes.screenInteraction = .dismiss
        // 点击遮罩层自动收起就set成.dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.5,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.35)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 6
            )
        )
        // 日常高度采用自动计算,也可以手动计算.constant(value: 265)
        attributes.positionConstraints.size = .init(
            width: .fill,
            height: .intrinsic
        )
        // 最大高度不超过屏幕的0.7
        attributes.positionConstraints.maxSize = .init(
            width: .fill,
            height: .ratio(value: 0.7)
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        // 默认弹窗不带圆角咯
        attributes.roundCorners = .all(radius: 0)
        attributes.statusBar = .dark
        return attributes
    }()

    // MARK: - Lazy Method
    private lazy var titleArea: UIView = {
        let _titleArea = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 52))
        return _titleArea
    }()

    private lazy var closeButton: QSButton = {
        let _closeButton = QSButton.init(normalImageName: "alert_icon_close")
        _closeButton.addTarget(self, action: #selector(clickCloseButtonAction), for: .touchUpInside)
        return _closeButton
    }()

    private lazy var titleLabel: QSLabel = {
        let _titleLabel = QSLabel(design: .heading16Bold, title: "Alert")
        return _titleLabel
    }()

    internal lazy var titleLine: UIView = {
        let _titleLine = UIView()
        _titleLine.backgroundColor = UIColor.lineEE
        return _titleLine
    }()
}
