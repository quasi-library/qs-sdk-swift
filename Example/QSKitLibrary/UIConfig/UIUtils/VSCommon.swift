//
//  VSCommon.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/12/9.
//

import Foundation
import UIKit

// TODO: 待删除，通过Router统一管理
func getCurrentVc() -> UIViewController? {
    if let rootVc = UIApplication.shared.keyWindow?.rootViewController {
        let currentVc = getCurrentVcFrom(rootVc)
        return currentVc
    }
    return nil
}

// TODO: 待删除，通过Router统一管理
private func getCurrentVcFrom(_ rootVc: UIViewController) -> UIViewController {
    var currentVc: UIViewController
    var rootCtr = rootVc
    if let presented = rootCtr.presentedViewController {
        rootCtr = presented
    }

    if rootVc.isKind(of: UITabBarController.classForCoder()) {
        currentVc = getCurrentVcFrom((rootVc as! UITabBarController).selectedViewController!)
    } else if rootVc.isKind(of: UINavigationController.classForCoder()) {
        currentVc = getCurrentVcFrom((rootVc as! UINavigationController).visibleViewController!)
    } else {
        currentVc = rootCtr
    }
    return currentVc
}
