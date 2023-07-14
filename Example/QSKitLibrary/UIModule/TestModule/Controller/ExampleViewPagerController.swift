//
//  ExampleViewPagerController.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import Foundation
import QSKitLibrary

class ExampleViewPagerController: QSBaseViewController {
    // MARK: - Property

    // MARK: - Init Method

    // MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "联动ViewPager"
        // Do any additional setup after loading the view.

        self.updateDaysUI(120)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        view.addSubview(scrollView)
        view.addSubview(confirmButton)

        scrollView.addSubview(blankView)
        scrollView.addSubview(tipsLabel)
        scrollView.addSubview(stagesPreview)
        scrollView.addSubview(recipeTitleLabel)
        scrollView.addSubview(recipeCtrlBtn)

        recipeCtrlBtn.addSubview(recipeNameLabel)
        recipeCtrlBtn.addSubview(recipeEntryImageView)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top).offset(-4)
        }

        blankView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth, height: 30))
        }

        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(blankView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        stagesPreview.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
//            make.height // 内部撑起
        }

        recipeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stagesPreview.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        recipeCtrlBtn.snp.makeConstraints { make in
            make.top.equalTo(recipeTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }

        recipeNameLabel.snp.makeConstraints { make in
            make.edges.equalTo(recipeCtrlBtn).inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 60))
        }

        recipeEntryImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }

        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-1)
        }
    }

    /// 请求接口后刷新丰收天数战术
    func updateDaysUI(_ days: Int) {
        let attributedString = NSMutableAttributedString(string: "Expected harvest in\n\(days) days")
        // 设置整体文本的字体和颜色
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .ABCDiatypeBold, size: 18) as Any,
            .foregroundColor: UIColor.textSubBrown
        ]
        attributedString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: attributedString.length)
        )

        // 设置数字部分的字体和颜色
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .ABCDiatypeBold, size: 40) as Any,
            .foregroundColor: UIColor.appMainGreen
        ]
        attributedString.setAttributes(
            numberAttributes,
            range: NSRange(location: 20, length: "\(days)".count)
        )

        // 设置换行的样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        // 使用 attributedString 进行文本显示
        self.tipsLabel.attributedText = attributedString
    }

    // MARK: - UI Action Method
    @objc private func pushToChooseRecipe(_ sender: UIButton) {
    }

    @objc private func pushToNext(_ sender: UIButton) {
        // 发起请求后代理跳转
    }

    // MARK: - Private Method
    private func checkBtnEnable() {
    }

    // MARK: - Lazy Method
    private lazy var scrollView: UIScrollView = {
        let _scroll = UIScrollView()
        _scroll.backgroundColor = .appBackgroundPage
        _scroll.showsVerticalScrollIndicator = false
        _scroll.showsHorizontalScrollIndicator = false
        _scroll.isDirectionalLockEnabled = true

        return _scroll
    }()

    private lazy var blankView: UIView = {
        let _blankView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 32, height: 30))
        _blankView.backgroundColor = .appMainClear
        return _blankView
    }()

    /// 丰收日标签
    private lazy var tipsLabel: UILabel = {
        let _label = QSLabel(
            design: .sectionTitleBold,
            title: "Expected harvest in \n - days",
            color: .textSubBrown
        )
        _label.textAlignment = .center
        _label.numberOfLines = 2
        _label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return _label
    }()

    private lazy var stagesPreview: QSProgressViewPager = {
        let _viewpager = QSProgressViewPager(
            stageList: ["1", "2", "3", "4", "5"],
            currentStage: "2"
        )
//        _viewpager.backgroundColor = .systemPink
        return _viewpager
    }()

    /// 挑选默认plan recipe
    private lazy var recipeTitleLabel: UILabel = {
        let _label = QSLabel(
            design: .body14Regular,
            title: "Recipe for device control",
            color: .textDescGray
        )
        _label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return _label
    }()

    private lazy var recipeCtrlBtn: UIControl = {
        let _spaceBtn = UIControl()
        _spaceBtn.backgroundColor = .appBackgroundList
        _spaceBtn.layer.cornerRadius = 8
        _spaceBtn.clipsToBounds = true

        _spaceBtn.addTarget(
            self,
            action: #selector(pushToChooseRecipe),
            for: .touchUpInside
        )
        return _spaceBtn
    }()

    private lazy var recipeNameLabel: UILabel = {
        let _label = QSLabel(
            design: .body16Medium,
            title: "standard recipe",
            color: .textMainBlack
        )
        _label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return _label
    }()

    private lazy var recipeEntryImageView: UIImageView = {
        let _entryImageView = QSImageView(imageName: "arrow_entry_common_20")
        return _entryImageView
    }()

    /// 确认按钮
    private lazy var confirmButton: UIButton = {
        let _nextBtn = QSButton(
            design: .heading16Bold,
            title: "Start grow".uppercased()
        )

        _nextBtn.setSolidBoardStyle(
            normal: (backgroundColor: .appMainGreen, textColor: .appMainWhite),
            disabled: (backgroundColor: .lineF4, textColor: .lineCC),
            cornerRadius: 2
        )

        _nextBtn.addTarget(
            self,
            action: #selector(pushToNext(_:)),
            for: .touchUpInside
        )

        _nextBtn.isEnabled = false
        return _nextBtn
    }()
}
