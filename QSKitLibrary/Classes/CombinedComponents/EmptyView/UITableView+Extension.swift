//
//  UITableView+Extension.swift
//  QuasiDemo
//
//  Created by Geminy on 2022/4/12.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import QSKitLibrary

/// 给TableView添加空页面视图
public extension UITableView {
    func showEmptyView (
        emptyType: VSMineEmptyType,
        btnText: String? = nil,   // 无按钮为nil
        target: Any? = nil,       // 无按钮为nil
        action: Selector? = nil   // 无按钮为nil
    ) {
        let backgroundView = UIView(frame: self.bounds)

        let tipsLabel = QSLabel(
            style: .body15Regular,
            title: emptyType.desc,
            color: .textDescGray
        )
        tipsLabel.textAlignment = .center

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
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-30)
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
        self.separatorStyle = .none
        self.tableHeaderView?.isHidden = true
        self.mj_footer?.isHidden = true
        self.reloadData()
    }

    func removeEmptyView() {
        self.backgroundView = nil
        self.tableHeaderView?.isHidden = false
        self.mj_footer?.isHidden = false
    }
}
