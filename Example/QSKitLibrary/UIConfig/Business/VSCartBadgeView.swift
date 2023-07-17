//
//  VSCartBadgeView.swift
//  QuasiDemo
//
//  Created by Soul on 2023/6/13.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import QSKitLibrary

class VSCartBadgeView: UIControl {
    // MARK: - Lifecycle Method
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.addSubSnaps()
        self.layoutSnaps()

        self.addTarget(self, action: #selector(clickToPush), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubSnaps()
        self.layoutSnaps()

        self.addTarget(self, action: #selector(clickToPush), for: .touchUpInside)
    }

    // MARK: - UI Layout Method
    private func addSubSnaps() {
        self.addSubview(cartImageView)
        self.addSubview(badgeView)
    }

    private func layoutSnaps() {
        cartImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview().offset(5)
        }

        badgeView.snp.makeConstraints { make in
            make.centerX.equalTo(cartImageView.snp.trailing)
            make.centerY.equalTo(cartImageView.snp.top)
        }
    }

    // MARK: - UI Action Method
    /// 展示加车后抖动动画
    func beginShakeAnimation() {
        let anima = CABasicAnimation(keyPath: "transform.rotation.z")
        anima.fromValue = -0.9
        anima.toValue = 0
        anima.duration = 0.2
        anima.repeatCount = 1
        anima.isRemovedOnCompletion = true
//        anima.fillMode = .forwards
        anima.delegate = self
        cartImageView.layer.add(anima, forKey: nil)
    }

    /// 刷新角标(数据来源UserInfoManager)
    func refreshBadge() {
        DispatchQueue.main.async {
            self.badgeView.badgeNumber = VSUserInfoManager.shared.cartNum
        }
    }

    /// 点击后跳转
    @objc private func clickToPush() {
    }

    // MARK: - Lazy Method
    private lazy var cartImageView: UIImageView = {
        let _cart = QSImageView(imageName: "nav_icon_cart")
        return _cart
    }()

    private lazy var badgeView: VSBadgeGreenView = {
        let _badgeView = VSBadgeGreenView(badgeNumber: VSUserInfoManager.shared.cartNum)
        return _badgeView
    }()
}

extension VSCartBadgeView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.refreshBadge()
        }
    }
}
