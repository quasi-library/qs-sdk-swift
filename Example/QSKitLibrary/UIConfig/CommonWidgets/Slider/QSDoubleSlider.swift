//
//  QSDoubleSlider.swift
//  doubleSlider
//
//  Created by Soul on 2022/10/13.
//

import Foundation
import QSKitLibrary
import SnapKit
import UIKit

@objc public protocol QSDoubleSliderDelegate: NSObjectProtocol {
    /// 完成左侧thumb滑动
    func didChangedLeftValue(_ sliderView: QSDoubleSlider, _ value: Double)
    /// 完成右侧thumb滑动
    func didChangedRightValue(_ sliderView: QSDoubleSlider, _ value: Double)
}

/// 带有两个点的slider滑动选择器
/// 总轨道长度相当于self.view减去两个半径，两个圆点的滑动范围以圆心为准
open class QSDoubleSlider: UIView {
    // MARK: - Public Property
    /// 代理，用于返回当前滑动事件触发之后的值
    public weak var delegate: QSDoubleSliderDelegate?
    /// 单位， 用于展示在数值标签；也可用于区分不同的slider
    public var unit: String = ""

    /// 当前展示左侧滑块的实际值
    public var currentLeftValue = 20.0
    /// 当前展示右侧滑块的实际值
    public var currentRightValue = 80.0

    // MARK: - Private Property
    /// slider左右边距（不能滑动的区域的宽度）
    private let sliderMargin = 0.0
    /// thumb直径
    private let thumbDiam = 30.0

    /// 设置可以滑动范围的最大值(如0~100，只可以在10～90无级滑动)
    private var totalMaxValue = 100.0
    /// 设置可以滑动范围的最小值(如0~100，只可以在10～90无级滑动)
    private var totalMinValue = 0.0
    /// 设备滑杆左端无级变速的值(如0~100，只可以在10～90无级滑动，在90～100时会自动赋值100)
    private var limitMaxValue = 90.0
    /// 设备滑杆右端无级变速的值(如0~100，只可以在10～90无级滑动，在0～10时会自动赋值0)
    private var limitMinValue = 10.0
    /// 自定义左端点时的提示文案（为空时展示值）
    private var mCustomTipsMin: String?
    /// 自定义右端点时的提示文案（为空时展示值）
    private var mCustomTipsMax: String?

    /// 每滑动1pt，相当于value修改的value
    private var stepValue = 1.0

    // MARK: - Lifecycle Method
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false

        setUpUI()
        layoutSnaps()
    }

    // MARK: - UI Layout Method
    private func setUpUI() {
        addSubview(backLineView)
        backLineView.addSubview(leftLineView)
        backLineView.addSubview(rightLineView)
        addSubview(leftThumbView)
        addSubview(rightThumbView)
        addSubview(leftTipsLabel)
        addSubview(rightTipsLabel)

        leftThumbView.layer.cornerRadius = thumbDiam * 0.5
        rightThumbView.layer.cornerRadius = thumbDiam * 0.5
    }

    private func layoutSnaps() {
        self.backLineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self).offset(sliderMargin + thumbDiam * 0.5)
            make.trailing.equalTo(self).offset(-(sliderMargin + thumbDiam * 0.5))
            make.height.equalTo(5)
        }

        self.leftLineView.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(self.backLineView)
        }

        self.rightLineView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(self.backLineView)
        }

        self.leftThumbView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(thumbDiam)
            make.centerX.equalTo(self.leftLineView.snp.trailing)
        }

        self.rightThumbView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.rightLineView.snp.leading)
            make.width.height.equalTo(thumbDiam)
        }

        self.leftTipsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.leftThumbView)
            make.bottom.equalTo(leftThumbView.snp.top).offset(-15)
        }

        self.rightTipsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.rightThumbView)
            make.bottom.equalTo(rightThumbView.snp.top).offset(-15)
        }
    }

    /// 当左右两点变化时，更新提示文字的标签
    private func updateTipsText(isLeft: Bool, realValue: Double) {
        var tipsLabel = self.leftTipsLabel
        if !isLeft {
            tipsLabel = self.rightTipsLabel
        }

        guard realValue >= totalMinValue && realValue <= totalMaxValue else {
            // 溢出两端时直接展示NO
            tipsLabel.text = "NO"
            return
        }

        if isLeft, realValue == self.totalMinValue, let startTips = self.mCustomTipsMin {
            // 已经到最小值，且有自定义文案时
            tipsLabel.text = startTips
        } else if isLeft == false, realValue == self.totalMaxValue, let endTips = self.mCustomTipsMax {
            // 已经到最小值，且有自定义文案时
            tipsLabel.text = endTips
        } else if unit.contains("°F") == true {
            // 适用于温湿度报警时 华氏度展示(此时传入的value是摄氏度)
            let showValue = transferToFahrenheit(celsius: realValue)
            tipsLabel.text = "\(Int(showValue))\(unit)"
        } else {
            // 通用的直接展示数值&单位
            tipsLabel.text = "\(Int(realValue))\(unit)"
        }
    }

    /// 当左右两点变化时，更新滑块展示
    private func updateSlider(currentLeft: Double, currentRight: Double) {
        debugPrint(self, #function, "更新滑块位置", currentLeft, currentRight)
        /// 总滑区域
        var sumSliderWidth = self.bounds.size.width - self.sliderMargin * 2
        if sumSliderWidth <= 0 { sumSliderWidth = 1}
        self.stepValue = (self.totalMaxValue - self.totalMinValue) / sumSliderWidth
//        debugPrint(self, "每移动1pt代表的stepValue", self.stepValue)

        let leftPercent = (currentLeft - totalMinValue) / (totalMaxValue - totalMinValue)
        // 更新左边线段长度
        self.leftLineView.snp.remakeConstraints { make in
            make.top.bottom.leading.equalTo(self.backLineView)
            make.width.equalTo(self.backLineView).multipliedBy(leftPercent)
        }

        let rightPrecent = (totalMaxValue - currentRight) / (totalMaxValue - totalMinValue)
        // 更新右侧线段长度
        self.rightLineView.snp.remakeConstraints { make in
            make.top.bottom.trailing.equalTo(self.backLineView)
            make.width.equalTo(self.backLineView).multipliedBy(rightPrecent)
        }
    }

    // MARK: - UI Action Method

    /// 设置可以滑动的数值范围
    /// - Parameters limitMin / limitMax: 有效的可以滑动的区域
    /// - Parameters totalMin / totalMax: 除了滑动区域外延长固定档位
    /// - Parameters startText / endText: 滑动到两端端点时的标签展示，传空则展示值
    public func setupLimitRange(
        totalMin: Double,
        totalMax: Double,
        limitMin: Double? = nil,
        limitMax: Double? = nil,
        startText: String? = nil,
        endText: String? = nil
    ) {
        self.totalMaxValue = totalMax
        self.totalMinValue = totalMin

        if let limitMax = limitMax, limitMax < totalMax {
            self.limitMaxValue = limitMax
        } else {
            self.limitMaxValue = totalMax
        }

        if let limitMin = limitMin, limitMin > totalMin {
            self.limitMinValue = limitMin
        } else {
            self.limitMinValue = totalMin
        }

        var sumSliderWidth = self.bounds.size.width - self.sliderMargin * 2 - self.thumbDiam
        if sumSliderWidth <= 0 { sumSliderWidth = 1}
        self.stepValue = (self.limitMaxValue - self.limitMinValue) / sumSliderWidth

        self.mCustomTipsMin = startText
        self.mCustomTipsMax = endText
    }

    /// 更新当前选中的值（范围）
    /// - parameters: left_vv  左侧的点值
    /// - parameters: right_vv  右侧的点值
    public func loadCurrentValue(_ leftValue: Double, _ rightValue: Double) {
        guard self.totalMaxValue > self.totalMinValue, self.limitMaxValue > self.limitMinValue else {
            print(self, "❌❌ 请先设置滑杆的最大值和最小值", self.totalMaxValue, self.totalMinValue)
            return
        }

        if leftValue != -6666, rightValue != -6666, leftValue > rightValue {
            // 当左侧值大于右侧值时返回
            print(self, "❌❌ 请检查滑杆当前的左值和右值", leftValue, rightValue)
            return
        }

        // 记录传入的数值&更新展示标签
        if leftValue < limitMinValue || leftValue == -6666 {
            self.currentLeftValue = self.totalMinValue
            self.bringSubview(toFront: self.rightThumbView)
        } else {
            self.currentLeftValue = leftValue
        }
        updateTipsText(isLeft: true, realValue: self.currentLeftValue)

        if rightValue > limitMaxValue || rightValue == -6666 {
            self.currentRightValue = self.totalMaxValue
            self.bringSubview(toFront: self.leftThumbView)
        } else {
            self.currentRightValue = rightValue
        }
        updateTipsText(isLeft: false, realValue: self.currentRightValue)

        // 更新滑块展示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.updateSlider(
                currentLeft: self.currentLeftValue,
                currentRight: self.currentRightValue
            )
        }
    }

    /// 滑动左侧滑块
    @objc private func leftPanMoved(_ sender: UIPanGestureRecognizer) {
        // 确认好滑块期望位置(手势终点)后幻化成value，并更新视图
        guard self.totalMaxValue > self.totalMinValue, self.limitMaxValue > self.limitMinValue else {
            print(self, #function, "❌❌ 请先设置滑杆的最大值和最小值", self.totalMaxValue, self.totalMinValue)
            return
        }

        switch sender.state {
        case .possible:
            break
        case .began:
            break
        case .changed:
            let leftPanX = sender.translation(in: self.leftThumbView).x
//            debugPrint(self, #function, "左侧按钮手势滑动距离", leftPanX)

            let duandian = self.backLineView.frame.origin.x
            // let qidian = self.leftThumbView.center.x - duandian
            let zhongdian = self.leftThumbView.center.x + leftPanX - duandian
            let sumSliderWidth = self.backLineView.frame.size.width
            let leftPercent = (zhongdian - duandian) / sumSliderWidth

            // 更新值
            var newLeftValue = self.totalMinValue + leftPercent * (self.totalMaxValue - self.totalMinValue)
//            debugPrint(self, "滑动左滑块之后新值", newLeftValue)
            if newLeftValue <= self.limitMinValue {
                newLeftValue = self.totalMinValue
            } else if newLeftValue >= self.currentRightValue {
                // 防重叠
                let minSpace = ceil((self.totalMaxValue - self.totalMinValue) * 0.01)
                newLeftValue = self.currentRightValue - minSpace
            } else {
                newLeftValue = floor(newLeftValue)
            }
            // debugPrint(self, "滑动左滑块之后计算的值", newLeftValue)
            self.currentLeftValue = newLeftValue
            updateTipsText(isLeft: true, realValue: self.currentLeftValue)
        case .ended:
            // 更新视图
            updateSlider(currentLeft: self.currentLeftValue, currentRight: self.currentRightValue)
            // 返回出去
            self.delegate?.didChangedLeftValue(self, self.currentLeftValue)
        case .cancelled:
            // 返回出去
            self.delegate?.didChangedLeftValue(self, self.currentLeftValue)
        case .failed:
            break
        @unknown default:
            break
        }
    }

    /// 滑动右侧滑块
    @objc private func rightPanMoved(_ sender: UIPanGestureRecognizer) {
        // 确认好滑块期望位置(手势终点)后幻化成value，并更新视图
        guard self.totalMaxValue > self.totalMinValue, self.limitMaxValue > self.limitMinValue else {
            print(self, #function, "❌❌ 请先设置滑杆的最大值和最小值", self.totalMaxValue, self.totalMinValue)
            return
        }

        switch sender.state {
        case .possible:
            break
        case .began:
            break
        case .changed:
            let rightPanX = sender.translation(in: self.rightThumbView).x
//            debugPrint(self, #function, "右侧按钮手势滑动距离", rightPanX)

            let duandian = self.backLineView.frame.origin.x + self.backLineView.frame.size.width
            let zhongdian = self.rightThumbView.center.x + rightPanX
            let sumSliderWidth = self.backLineView.frame.size.width
            let rightPercent = (duandian - zhongdian) / sumSliderWidth

            // 更新值
            var newRightValue = self.totalMaxValue - rightPercent * (self.totalMaxValue - self.totalMinValue)
//            debugPrint(self, "滑动右滑块之后新值", newRightValue)
            if newRightValue <= self.currentLeftValue {
                // 防重叠
                let minSpace = ceil((self.totalMaxValue - self.totalMinValue) * 0.01)
                newRightValue = self.self.currentLeftValue + minSpace
            } else if newRightValue >= self.limitMaxValue {
                newRightValue = self.totalMaxValue
            } else {
                newRightValue = floor(newRightValue)
            }
            // debugPrint(self, "滑动右滑块之后计算的值", newRightValue)
            self.currentRightValue = newRightValue
            updateTipsText(isLeft: false, realValue: self.currentRightValue)
        case .ended:
            // 更新视图
            updateSlider(currentLeft: self.currentLeftValue, currentRight: self.currentRightValue)
            // 返回出去
            self.delegate?.didChangedRightValue(self, self.currentRightValue)
        case .cancelled:
            // 返回出去
            self.delegate?.didChangedRightValue(self, self.currentRightValue)
        case .failed:
            break
        @unknown default:
            break
        }
    }

    // MARK: - Private Method
    /// 摄氏度转华氏度，用于展示
    private func transferToFahrenheit(celsius: Double) -> Double {
        if celsius == -6666 {
            return -6666
        }
        let df = 32 + (Double(celsius) * 1.8)
        return df
    }

    // MARK: - Lazy Method
   private lazy var leftThumbView: UIView = {
       let leftThumbView = UIView()
       leftThumbView.backgroundColor = UIColor.appMainWhite
       leftThumbView.layer.shadowColor = UIColor.hex("BBBBBB").cgColor
       leftThumbView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
       leftThumbView.layer.shadowOpacity = 1
       leftThumbView.layer.shadowRadius = 4

        let leftPan = UIPanGestureRecognizer()
        leftPan.addTarget(self, action: #selector(leftPanMoved(_:)))
        leftThumbView.addGestureRecognizer(leftPan)
        return leftThumbView
    }()

    private lazy var rightThumbView: UIView = {
        let rightThumbView = UIView()
        rightThumbView.backgroundColor = UIColor.appMainWhite
        rightThumbView.layer.shadowColor = UIColor.hex("BBBBBB").cgColor
        rightThumbView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        rightThumbView.layer.shadowOpacity = 1
        rightThumbView.layer.shadowRadius = 4

        let rightPan = UIPanGestureRecognizer()
        rightPan.addTarget(self, action: #selector(rightPanMoved(_:)))
        rightThumbView.addGestureRecognizer(rightPan)
        return rightThumbView
    }()

    private lazy var backLineView: UIView = {
        let backLineView = UIView()
        backLineView.backgroundColor = UIColor.appBackgroundList
        return backLineView
    }()

    private lazy var leftLineView: UIView = {
        let leftLineView = UIView()
        leftLineView.backgroundColor = .iotMeterColor
        return leftLineView
    }()

    private lazy var rightLineView: UIView = {
        let rightLineView = UIView()
        rightLineView.backgroundColor = UIColor.textWarnRed
        return rightLineView
    }()

    private lazy var leftTipsLabel: UILabel = {
        let leftTipsLabel = QSLabel(style: .body13Regular, title: "")
        leftTipsLabel.textAlignment = .center
        leftTipsLabel.backgroundColor = UIColor.clear
        leftTipsLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        return leftTipsLabel
    }()

    private lazy var rightTipsLabel: UILabel = {
        let rightTipsLabel = QSLabel(style: .body13Regular, title: "")
        rightTipsLabel.textAlignment = .center
        rightTipsLabel.backgroundColor = UIColor.clear
        rightTipsLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        return rightTipsLabel
    }()
}
