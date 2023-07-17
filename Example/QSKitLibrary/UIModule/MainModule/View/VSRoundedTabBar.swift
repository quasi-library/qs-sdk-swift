//
//  VSRoundedTabBar.swift
//  QuasiDemo
//
//  Created by Soul on 2023/6/7.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

/// 上圆角下直角的Tabbar
class VSRoundedTabBar: UITabBar {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(dividedLine)
        dividedLine.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius: CGFloat = 0.0
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    // MARK: - Lazy Method
    private lazy var dividedLine: UIView = {
        let _dividedLine = UIView()
        _dividedLine.backgroundColor = .lineE1

        return _dividedLine
    }()
}
