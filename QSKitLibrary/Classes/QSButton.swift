//
//  QSButton.swift
//  QSKitLibrary
//
//  Created by GengJian on 2022/3/8.
//  Copyright © 2022 Quasi Team. All rights reserved.
//

import UIKit

open class QSButton: UIButton {
    /**
        一键设置空心带包边样式（默认黑边白心）
     */
   public func setHollowStyle(
        borderColor:UIColor = .black,
        borderWidth:CGFloat = 0.5) {
            self.setTitleColor(borderColor, for: .normal)
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = 0.5
            self.layer.borderColor = borderColor.cgColor
            self.clipsToBounds = true
    }
    
    /**
        一键设置实心样式（默认黑底白字）
     */
   public func setSolidStyle(
        textColor:UIColor = .white,
        backgroundColor:UIColor = .black,
        borderWidth:CGFloat = 0.5) {
            self.setTitleColor(textColor, for: .normal)
            self.backgroundColor = backgroundColor
            self.layer.borderWidth = 0.0
            self.layer.cornerRadius = 0.5
            self.clipsToBounds = true
    }
    
}
