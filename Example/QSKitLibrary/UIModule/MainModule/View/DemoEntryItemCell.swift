//
//  DemoEntryItemCell.swift
//  QuasiDemo
//
//  Created by Soul on 2023/6/25.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import QSKitLibrary

/// 购物车信息
class DemoEntryItemCell: QSTableViewCell {
    // MARK: - Property
    private var totalTimeInSeconds = 0
    /// 正在输入数量的状态
    private var isCompleted = false

    // MARK: - Init / Public Method
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func loadItemModel(_ model: DemoSimpleListViewModel.Entry) {
        self.productNameLabel.text = model.entryName
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        self.contentView.backgroundColor = .appMainWhite

        contentView.addSubview(chooseIcon)
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(optionValueLabel)
        contentView.addSubview(extraStack)

        contentView.addSubview(soldoutLabel)

        extraStack.addArrangedSubview(originalPriceLabel)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        productImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 92, height: 92))
            make.leading.equalTo(chooseIcon.snp.trailing)
            make.top.equalToSuperview().offset(20)
        }

        chooseIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(productImageView)
        }

        productNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-10)
            make.top.equalTo(productImageView)
            make.height.greaterThanOrEqualTo(36)
        }

        optionValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
        }

        extraStack.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.top.equalTo(optionValueLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-16)
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        soldoutLabel.snp.makeConstraints { make in
            make.center.equalTo(productImageView)
        }
    }

    // MARK: - Lazy Method
    private lazy var chooseIcon: QSButton = {
        let _btn = QSButton(normalImageName: "common_checkbox_nor")
        _btn.setImage(UIImage(named: "common_checkbox_sel_green"), for: .selected)
        // 设置图片内边距，将图片向外扩展 10 个点，扩大点击范围
        _btn.contentEdgeInsets = UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10)
//        _btn.backgroundColor = .systemYellow
        return _btn
    }()

    private lazy var productImageView: UIImageView = {
        let _imageView = UIImageView()
        return _imageView
    }()

    private lazy var productNameLabel: QSLabel = {
        let _nameLabel = QSLabel(design: .body14Regular, title: "-")
        _nameLabel.numberOfLines = 2
        _nameLabel.minimumScaleFactor = 1.0

        return _nameLabel
    }()

    private lazy var optionValueLabel: QSLabel = {
        let _optLabel = QSLabel(design: .body12Bold, title: "")
        _optLabel.contentInset = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        _optLabel.backgroundColor = .appBackgroundList

        _optLabel.isHidden = true
        return _optLabel
    }()

    /// 包含划线价以及定时价格等动态展示的区域
    private lazy var extraStack: UIStackView = {
        let _stack = UIStackView()
        _stack.axis = .vertical
        _stack.alignment = .leading
        _stack.spacing = 5

        return _stack
    }()

    /// 原价
    private lazy var originalPriceLabel: QSLabel = {
        let _label = QSLabel(design: .body14Regular, title: "-", color: .textTipsGray)

        _label.isHidden = true
        return _label
    }()

    /// 下架
    private lazy var soldoutLabel: QSLabel = {
        let _nameLabel = QSLabel(design: .body14Bold, title: "Sold out")
        _nameLabel.isHidden = true
        return _nameLabel
    }()
}
