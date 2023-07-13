//
//  QSWraparoundTextField.swift
//  QuasiDemo
//
//  Created by Soul on 2023/6/12.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import SnapKit

class QSWraparoundTextField: QSTextField {
    // MARK: - Property
    private let kPadding: CGFloat = 8.0
    private var mRightBlock: () -> Void = {
        debugPrint(QSWraparoundTextField.self, "点击右侧图标")
    }

    // MARK: - Initialization Method

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// 构造方法
    convenience init(
        hint: String?,
        leftImageName: String?,
        shouldSecured: Bool,
        rightImageName: String?,
        rightClickBlock: (() -> Void)?
    ) {
        self.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 32, height: 46))

        self.tintColor = .appMainGreen
        self.placeholder = hint

        // 设置左右图标
        if let leftImageName, let leftImage = UIImage(named: leftImageName) {
            setupLeftView(leftImage)
        } else {
            // 输入区域距离左边框由contentInset实现
            self.leftViewMode = .never
        }

        if shouldSecured {
            self.isSecureTextEntry = true
            setupEyeView()
        } else if let rightImageName, UIImage(named: rightImageName) != nil {
            if let rightClickBlock {self.mRightBlock = rightClickBlock}
            setupRightView(rightImageName)
        } else {
            self.rightView = nil
            self.rightViewMode = .never
        }
    }

    private func commonInit() {
        // 设置外边框样式和颜色
        self.borderStyle = .none
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lineE1.cgColor
        self.layer.cornerRadius = 2.0

        self.clearButtonMode = .whileEditing
        self.returnKeyType = .done

        // 添加文本字段代理
        self.delegate = self
    }

    // MARK: - UI Layout Method
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private func setupLeftView(_ image: UIImage) {
        let leftImageView = UIImageView(image: image)
        leftImageView.contentMode = .scaleAspectFit

        // 调整左侧图标与边框的间距
        let leftViewWidth = leftImageView.frame.size.width + kPadding * 2
        let leftViewHeight = self.frame.size.height
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewWidth, height: leftViewHeight))
        leftView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(kPadding)
            make.trailing.equalToSuperview().offset(-kPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        self.leftView = leftView
        self.leftViewMode = .always
    }

    private func setupRightView(_ imageName: String) {
        let rightButton = QSButton(normalImageName: imageName)  // 设置按钮的图像
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20) // 设置按钮的尺寸
        rightButton.contentMode = .center
        rightButton.addTarget(self, action: #selector(rightBtnClick(_:)), for: .touchUpInside)

        // 调整右侧图标的边距
        let rightViewWidth = 20.0 + kPadding
        let rightViewHeight = self.frame.size.height
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightViewWidth, height: rightViewHeight))
//        rightView.backgroundColor = .green
        rightView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-kPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        self.rightView = rightView
        self.rightViewMode = .always
    }

    private func setupEyeView() {
        self.showEyeBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20) // 设置按钮的尺寸
        let rightButton = self.showEyeBtn

        // 调整右侧图标的边距
        let rightViewWidth = 20.0 + kPadding
        let rightViewHeight = self.frame.size.height
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightViewWidth, height: rightViewHeight))
//        rightView.backgroundColor = .green
        rightView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-kPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        self.rightView = rightView
        self.rightViewMode = .always
    }

    // MARK: - UI Action Method
    /// 点击眼睛处理是否加密
    @objc private func pwdEyeBtnClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.isSecureTextEntry = sender.isSelected
    }

    /// 点击右侧自定义图片触发事件
    @objc private func rightBtnClick(_ sender: UIButton) {
        self.mRightBlock()
    }

    // MARK: - Lazy Method
    private lazy var showEyeBtn: UIButton = {
        let pwdEyeBtn = QSButton(
            normalImageName: "common_input_eye_on",
            selectedImageName: "common_input_eye_off"
        )
        pwdEyeBtn.addTarget(self, action: #selector(pwdEyeBtnClick(_:)), for: .touchUpInside)
        pwdEyeBtn.isSelected = true
        return pwdEyeBtn
    }()
}

extension QSWraparoundTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 编辑时设置外边框为黑色
        self.layer.borderColor = textField.textColor?.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // 结束编辑时设置外边框为灰色
        self.layer.borderColor = UIColor.lineE1.cgColor
    }

    /// 当点击键盘上的 "Done" 按钮时调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 收起键盘
        return true
    }
}
