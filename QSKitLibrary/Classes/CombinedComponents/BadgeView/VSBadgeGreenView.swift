//
//  BadgeGreenView.swift
//  QuasiDemo
//
//  Created by Soul on 2023/5/23.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

/// 带有白圈的绿底角标视图
public class VSBadgeGreenView: QSView {
    // MARK: - Property
    public var badgeNumber: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                if self.badgeNumber < 1 {
                    self.isHidden = true
                } else if self.badgeNumber > 99 {
                    self.countLabel.text = "99+"
                    self.isHidden = false
                } else {
                    self.countLabel.text = "\(self.badgeNumber)"
                    self.isHidden = false
                }
            }
        }
    }

    // MARK: - Init Method
    /// 构造方法
    public init(badgeNumber: Int) {
        super.init(frame: .zero)

        self.badgeNumber = badgeNumber
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        self.addSubview(outView)

        outView.addSubview(countView)

        outView.addSubview(countLabel)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        outView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        countView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
            make.width.greaterThanOrEqualTo(countView.snp.height)
        }

        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
        }
    }

    // MARK: - Lazy Method
    /// 主图
    private lazy var outView: UIView = {
        let _outView = UIView()
        _outView.backgroundColor = .appMainWhite
        _outView.layer.cornerRadius = 8
//        _outView.layer.borderColor = UIColor.appMainGreen.withAlphaComponent(0.1).cgColor
//        _outView.layer.borderWidth = 1
        return _outView
    }()

    private lazy var countView: UIView = {
        let _countView = UIView()
        _countView.backgroundColor = .appMainGreen
        _countView.layer.cornerRadius = 8
        return _countView
    }()

    private lazy var countLabel: UILabel = {
        let _countLabel = QSLabel(
            design: .body12Regular,
            title: "0",
            color: .appMainWhite
        )
        _countLabel.textAlignment = .center
//        _countLabel.contentInset = .init(top: 0, left: 2, bottom: 0, right: 2)
        return _countLabel
    }()
}
