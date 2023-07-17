//
//  UICollectionView+Extension.swift
//  QuasiDemo
//
//  Created by Geminy on 2022/8/24.
//  Copyright © 2022 Sinowell Inc. All rights reserved.
//

import Foundation
import QSKitLibrary
import UIKit

public extension UICollectionView {
    /// 展示空页面底图
    /// - Parameters emptyDesc: 每个type有默认文案，若业务不同时自定义文案则传入此字段
    func showEmptyView (
        emptyType: VSMineEmptyType,
        emptyDesc: String? = nil,
        btnText: String? = nil,   // 无按钮为nil
        target: Any? = nil,       // 无按钮为nil
        action: Selector? = nil   // 无按钮为nil
    ) {
        let backgroundView = UIView(frame: self.bounds)

        let tipsLabel = QSLabel(
            design: .body15Regular,
            title: emptyType.desc,
            color: .textDescGray
        )
        tipsLabel.textAlignment = .center
        if let emptyDesc {
            tipsLabel.text = emptyDesc
        }

        let imageView = QSImageView(imageName: emptyType.imageName)

        let tryBtn = QSButton(design: .body14Bold, title: btnText)
        tryBtn.setSolidBoardStyle()
        if let action = action {
            tryBtn.addTarget(target, action: action, for: .touchUpInside)
        }

        backgroundView.addSubview(tipsLabel)
        backgroundView.addSubview(imageView)
        tipsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(tipsLabel.snp.top).offset(-13)
            make.centerX.equalToSuperview()
        }

        if btnText?.isBlank == false {
            backgroundView.addSubview(tryBtn)
            tryBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(tipsLabel.snp.bottom).offset(30)
                make.height.equalTo(46)
                make.width.greaterThanOrEqualTo(237)
            }
        }

        self.backgroundView = backgroundView
//        self.separatorStyle = .none
//        self.tableHeaderView?.isHidden = true
        self.reloadData()
    }

    func removeEmptyView() {
        self.backgroundView = nil
//        self.tableHeaderView?.isHidden = false
    }
}
