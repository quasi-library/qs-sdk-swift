//
//  VSNavigationController.swift
//  QuasiDemo
//
//  Created by Geminy on 2021/10/28.
//

import UIKit

public protocol ShouldPopDelegate: NSObjectProtocol {
    // 拦截返回按钮的点击事件
    func currentViewControllerShouldPop() -> Bool
}

@objc extension UIViewController: ShouldPopDelegate {
    public func currentViewControllerShouldPop() -> Bool {
        return true
    }
}

public class VSNavigationController: UINavigationController, UINavigationControllerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()

//        self.delegate = self
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.layer.shadowColor = .hex(0xc9c9c9)
//        self.navigationBar.layer.shadowRadius = 20
//        self.navigationBar.layer.shadowOpacity = 0.2
//        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.navigationBar.tintColor = UIColor.white
//        self.navigationBar.isTranslucent = false
//        self.navigationBar.barTintColor = .white
//
//        let appearance = UINavigationBar.appearance()
//        appearance.shadowImage = UIImage()
//        appearance.layer.shadowColor = .hex(0xc9c9c9)
//        appearance.layer.shadowRadius = 20
//        appearance.layer.shadowOpacity = 0.2
//        appearance.layer.shadowOffset = CGSize(width: 0, height: 5)
//        appearance.tintColor = UIColor.white //前景色，按钮颜色
//        appearance.isTranslucent = false // 导航条背景是否透明
//        appearance.barTintColor = .white //背景色，导航条背景色
//        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)] // 设置导航条标题颜色，还可以设置其它文字属性，只需要在里面添加对应的属性
//
//        if #available(iOS 15.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .appMainGreen
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]
//            navigationBar.standardAppearance = appearance
//            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
//        }
    }

    /// 默认不允许自动转屏
    public override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension VSNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if self.viewControllers.count < navigationBar.items?.count ?? 1 {
            return true
        }
        var shouldPop = true
        // 看一下当前控制器有没有实现代理方法 currentViewControllerShouldPop
        // 如果实现了，根据当前控制器的代理方法的返回值决定
        // 没过没有实现 shouldPop = YES
        if let currentVC = self.topViewController,
            currentVC.responds(to: #selector(currentViewControllerShouldPop)) {
            shouldPop = currentVC.currentViewControllerShouldPop()
        }

        if shouldPop == true {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            // 让系统backIndicator 按钮透明度恢复为1
            for subview in navigationBar.subviews {
                if subview.alpha > 0.0 && subview.alpha < 1.0 {
                    UIView.animate(
                        withDuration: 0.25
                    ) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
}
