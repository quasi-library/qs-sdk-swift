//
//  QSBubbleDialogView.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import UIKit
import QSKitLibrary

/// 气泡样式边框
class QSBubbleDialogView: QSView {
    // MARK: - Property
    /// 气泡样式的边框
    private weak var mShapeLayer: CAShapeLayer?

    public var mBubbleModel: String?

    // MARK: - Init / Public Method
    init(_ mBubbleModel: String) {
        super.init(frame: .zero)

        self.mBubbleModel = mBubbleModel
        self.stageNameLabel.text = mBubbleModel
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        self.addSubview(containerView)

        containerView.addSubview(stageNameLabel)
        containerView.addSubview(stageDaysLabel)
        containerView.addSubview(stageDescLabel)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        self.containerView.snp.makeConstraints { make in
            // 因为气泡包边预留1的宽度
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        }

        stageNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(24)
        }

        stageDaysLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stageNameLabel)
            make.leading.equalTo(stageNameLabel.snp.trailing).offset(15)
        }

        stageDescLabel.snp.makeConstraints { make in
            make.top.equalTo(stageNameLabel.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
//            make.height.equalTo(80)
        }
    }

    /// - NOTE: 使用setNeedsDisplay()方法手动调用，告诉系统视图需要重绘。
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        mShapeLayer?.removeFromSuperlayer()

        let cornerRadius: CGFloat = 8
        let triangleHeight: CGFloat = 6         // 底是高的两倍
        var triangleCenterX = self.containerView.bounds.width / 2  // 默认中点

        let bubblePath = UIBezierPath()

        // 创建三角形路径
        bubblePath.move(to: CGPoint(x: triangleCenterX - triangleHeight, y: triangleHeight))
        bubblePath.addLine(to: CGPoint(x: triangleCenterX, y: 0))
        bubblePath.addLine(to: CGPoint(x: triangleCenterX + triangleHeight, y: triangleHeight))
        // 创建圆角矩形路径
        let topRightPoint = CGPoint(x: self.containerView.bounds.width - cornerRadius, y: triangleHeight)
        let rightTopPoint = CGPoint(x: self.containerView.bounds.width, y: triangleHeight + cornerRadius)
        let rightBottomPoint = CGPoint(x: self.containerView.bounds.width, y: self.containerView.bounds.height - cornerRadius)
        let bottomRightPoint = CGPoint(x: self.containerView.bounds.width - cornerRadius, y: self.containerView.bounds.height)
        let bottomLeftPoint = CGPoint(x: cornerRadius, y: self.containerView.bounds.height)
        let leftBottomPoint = CGPoint(x: 0, y: self.containerView.bounds.height - cornerRadius)
        let leftTopPoint = CGPoint(x: 0, y: triangleHeight + cornerRadius)
        let topLeftPoint = CGPoint(x: cornerRadius, y: triangleHeight)

        let curveOffset = cornerRadius * cos(45 / 180 * .pi)
        bubblePath.addLine(to: topRightPoint)
        bubblePath.addQuadCurve(
            to: rightTopPoint,
            controlPoint: CGPoint(x: topRightPoint.x + curveOffset, y: rightTopPoint.y - curveOffset)
        )
        bubblePath.addLine(to: rightBottomPoint)
        bubblePath.addQuadCurve(
            to: bottomRightPoint,
            controlPoint: CGPoint(x: bottomRightPoint.x + curveOffset, y: rightBottomPoint.y + curveOffset)
        )
        bubblePath.addLine(to: bottomLeftPoint)
        bubblePath.addQuadCurve(
            to: leftBottomPoint,
            controlPoint: CGPoint(x: bottomLeftPoint.x - curveOffset, y: leftBottomPoint.y + curveOffset)
        )
        bubblePath.addLine(to: leftTopPoint)
        bubblePath.addQuadCurve(
            to: topLeftPoint,
            controlPoint: CGPoint(x: topLeftPoint.x - curveOffset, y: leftTopPoint.y - curveOffset)
        )

        // 将三角形路径的起点和终点连接到圆角矩形路径
        bubblePath.close()

        // 创建形状图层并添加路径
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bubblePath.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.appMainGreen.cgColor
        shapeLayer.fillColor = UIColor.appMainClear.cgColor
        shapeLayer.cornerRadius = cornerRadius

        // 添加形状图层到容器视图的图层
        containerView.layer.addSublayer(shapeLayer)
        self.mShapeLayer = shapeLayer
    }

    // MARK: - Lazy Method
    private lazy var containerView: UIView = {
        let _containerView = UIView()
//        _containerView.backgroundColor = .appMainYellow

        return _containerView
    }()

    /// 标题
    private lazy var stageNameLabel: UILabel = {
        let _label = QSLabel(
            design: .heading20Bold,
            title: "Seedling",
            color: .textMainBlack
        )
        _label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return _label
    }()

    /// 补充副标题
    private lazy var stageDaysLabel: UILabel = {
        let _label = QSLabel(
            design: .heading16Bold,
            title: "25 days",
            color: .textMainBlack
        )

        return _label
    }()

    /// 下方描述
    private lazy var stageDescLabel: UILabel = {
        let _label = QSLabel(
            design: .body14Regular,
            title: "Seedling stage normally last for 2 weeks. In this stage, the seed or clone will prepare for vegetative with leaves and roots. the seed or clone will prepare for vegetative with leaves a...",
            color: .textMainBlack
        )
        _label.numberOfLines = 4
        _label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        _label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        _label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        return _label
    }()
}
