//
//  VSClockSharpPicker.swift
//  QuasiDemo
//
//  Created by Soul on 2022/10/25.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit
import QSKitLibrary

/// 整点的时钟选择器(如 3:00 AM / 12:00 PM)
/// - NOTE: 如选offset时展示使用
 class VSClockSharpPicker: UIView {
    // MARK: - Property
    private var isSupportMinutes = false
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    private var selectedNoon: Int = 0   // 0:AM, 1:PM
    private var cancelBlock: (() -> Void)? = {
        debugPrint(VSClockSharpPicker.self, "点击弹窗中的取消按钮")
    }
    private var confirmBlock: ((TimeInterval, String) -> Void)? = { time, desc in
        debugPrint(VSClockSharpPicker.self, "点击弹窗中的确认按钮，新的时间戳为", time as Any, desc as Any)
    }

    // MARK: - Init Method
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        layoutSubSnps()
    }

    /// 便利构造器
    /// - Parameters: supportMinutes 是否展示分钟那一列
    convenience init(
        defaultTime: TimeInterval?,
        supportMinutes: Bool = true,
        cancelBlock: (() -> Void)?,
        confirmBlock: ((TimeInterval, String) -> Void)?
    ) {
        self.init(frame: .zero)

        self.isSupportMinutes = supportMinutes
        self.cancelBlock = cancelBlock
        self.confirmBlock = confirmBlock

        if defaultTime != nil {
            updateSelectedTime(defaultTime: defaultTime)
        }
    }

     func updateSelectedTime(defaultTime: TimeInterval?) {
         if let selTime = defaultTime {
             let hour = Int(selTime) / 3600
             if hour >= 12 {
                 self.selectedHour = hour - 12
                 self.selectedNoon = 1
             } else {
                 self.selectedHour = hour
                 self.selectedNoon = 0
             }

             if self.isSupportMinutes {
                 let m = (Int(selTime) - hour * 3600) % 60
                 self.selectedMinute = m
             }

             DispatchQueue.main.async {
                 self.clockPickerView.selectRow(self.selectedHour, inComponent: 0, animated: true)
                 self.clockPickerView.selectRow(self.selectedMinute, inComponent: 1, animated: true)
                 self.clockPickerView.selectRow(self.selectedNoon, inComponent: 2, animated: true)
             }
         }
     }

    // MARK: - UI Layout Method
    private func addSubViews() {
        self.addSubview(titleView)
        titleView.addSubview(cancelButton)
        titleView.addSubview(doneButton)

        self.addSubview(clockPickerView)
    }

    private func layoutSubSnps() {
        titleView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.height.equalToSuperview()
        }

        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.height.equalToSuperview()
        }

        clockPickerView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalToSuperview().offset(-35)
            make.centerX.equalToSuperview()
        }
    }


    // MARK: - UI Action Method
    /// 点击取消按钮
    @objc private func cancelClickedAction(sender: UIButton) {
        cancelBlock?()
    }

    /// 点击完成按钮
    @objc private func doneClickedAction(sender: UIButton) {
        var sum = self.selectedHour * 3600 + self.selectedMinute * 60
        if self.selectedNoon == 1 {
            sum += (3600 * 12)
        }
        let selectedTimeInterval = TimeInterval(sum)
        let desc = self.convertTntervalToDesc(selectedTimeInterval)
        confirmBlock?(selectedTimeInterval, desc)
    }


    // MARK: - Private Method
    /// 将选中的新的时间戳转化成12进制用于展示
    private func convertTntervalToDesc(_ offset: TimeInterval) -> String {
        let seconds = Int(offset)
        let desc = VSDateHandler.formatSecondsTo12TimeString(seconds)
        return desc
    }

    // MARK: - Lazy Method
     private lazy var titleView: UIView = {
        let _titleView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 52))
        _titleView.backgroundColor = .appMainWhite
        return _titleView
    }()

     private lazy var cancelButton: UIButton = {
        let _cancelButton = QSButton(
            design: .body16Regular,
            title: "Cancel",
            color: .appMainGreen
        )
        _cancelButton.addTarget(
            self,
            action: #selector(cancelClickedAction),
            for: .touchUpInside
        )
        return _cancelButton
    }()

     private lazy var doneButton: UIButton = {
        let _doneButton = QSButton(
            design: .buttonTitle16Bold,
            title: "Done",
            color: .appMainGreen
        )
         _doneButton.addTarget(
            self,
            action: #selector(doneClickedAction),
            for: .touchUpInside
        )
        return _doneButton
    }()

   private lazy var clockPickerView: UIPickerView = {
        let _clockPickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: kScreenWidth, height: 240))
        _clockPickerView.backgroundColor = .appMainWhite
        _clockPickerView.delegate = self

        return _clockPickerView
    }()

     private let hoursDataSource = [Int](0...11)
     private let minutesDataSource = [Int](0...59)
     private let noonDataSource = ["AM", "PM"]
 }

 extension VSClockSharpPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hoursDataSource.count
        case 2:
            return noonDataSource.count
        default:
            return 1
        }
    }

     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         switch component {
         case 0:
            let i = hoursDataSource[row]
             if i == 0 {
                 return "12"
             } else {
                 return String(format: "%2d", i)
             }
         case 1:
             if self.isSupportMinutes {
                 return String(format: "%2d", minutesDataSource[row])
             } else {
                 return "00"
             }
         case 2:
             return noonDataSource[row]
         default:
             return "null"
         }
     }

     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         switch component {
         case 0:
             self.selectedHour = row
         case 1:
             self.selectedMinute = row
         case 2:
             self.selectedNoon = row
         default:
             break
         }
     }
 }
