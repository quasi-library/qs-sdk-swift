//
//  QSViewPagerIndicatorItem.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import UIKit
import QSKitLibrary


public class QSViewPagerIndicatorItem: QSCollectionViewItem {
    // MARK: - Property
    enum Location {
        case first, center, last
    }
    enum Status {
        case before, current, after
    }

    private var mLocation: QSViewPagerIndicatorItem.Location = .center

    private var mStatus: QSViewPagerIndicatorItem.Status = .before

    private weak var mShapeLayer: CAShapeLayer?

    // MARK: - Init / Public Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 构造方法
    func loadItem(
        stageName: String,
        location: QSViewPagerIndicatorItem.Location,
        status: QSViewPagerIndicatorItem.Status
    ) {
        self.indicatorLabel.text = stageName
        self.mLocation = location
        self.mStatus = status

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    // MARK: - UI Layout Method
    public override func addSubSnaps() {
        super.addSubSnaps()

        self.addSubview(indicatorLine)
        self.addSubview(indicatorLabel)
    }

    public override func layoutSnaps() {
        super.layoutSnaps()

        indicatorLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
            make.top.equalToSuperview().offset(1)
        }

        indicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(indicatorLine.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if let oldLayer = mShapeLayer {
            oldLayer.removeFromSuperlayer()
        }

        let maskLayer = CAShapeLayer()
        // 更新圆角展示
        var cornerRadii: UIRectCorner = []
        switch mLocation {
        case .first:
            cornerRadii = [.topLeft, .bottomLeft]
        case .center:
            cornerRadii = []
        case .last:
            cornerRadii = [.topRight, .bottomRight]
        }

        let path = UIBezierPath(
            roundedRect: indicatorLine.bounds,
            byRoundingCorners: cornerRadii,
            cornerRadii: CGSize(width: 8, height: 8)
        )
        maskLayer.path = path.cgPath

        // 更新指示颜色
        var strokeColor: UIColor = .appMainGreen
        var fillColor: UIColor = .appMainLightBrown

        switch self.mStatus {
        case .before:
            fillColor = .appMainGreen
        case .current:
            fillColor = UIColor(hex: 0xF3FCF6)
        case .after:
            strokeColor = UIColor(hex: 0xCBC4BC)
        }

        maskLayer.strokeColor = strokeColor.cgColor
        maskLayer.fillColor = fillColor.cgColor

        maskLayer.borderWidth = 1.0
        indicatorLine.layer.addSublayer(maskLayer)
        self.mShapeLayer = maskLayer
    }

    // MARK: - Lazy Method
    /// 上方进度条，首尾圆角其余直角，状态不同填充颜色不同
    private lazy var indicatorLine: UIView = {
        let _indicatorLine = UIView()
        _indicatorLine.backgroundColor = .appMainClear

         return _indicatorLine
    }()

    private lazy var indicatorLabel: UILabel = {
        let _nameLabel = QSLabel(
            design: .body13Regular,
            title: "StageName",
            color: .textSubBrown
        )
        _nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return _nameLabel
    }()
}
