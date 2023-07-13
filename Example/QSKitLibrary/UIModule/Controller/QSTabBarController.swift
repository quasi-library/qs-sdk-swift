//
//  QSTabBarController.swift
//  QuasiDemo
//
//  Created by Soul on 2023/6/13.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit
import QSKitLibrary
import RxSwift

class QSTabBarController: UITabBarController {
    // MARK: - Property
    private let mDisposeBag = DisposeBag()
    private weak var meNav: UIViewController?

    // MARK: - Lifecycle Method
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func loadView() {
        super.loadView()

        let roundedTabBar = VSRoundedTabBar()
        setValue(roundedTabBar, forKey: "tabBar")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBuildVersion()
        self.bindViewModel()
        self.makeInitRequest()

        let growNav = createSubNav(
            title: "Garden",
            classType: GrowIndexController.self,
            imagePrefix: "grow"
        )

        let shopNav = createSubNav(
            title: "Shop",
            classType: ShopMallController.self,
            imagePrefix: "mall"
        )

        let meNav = createSubNav(
            title: "Me",
            classType: MineController.self,
            imagePrefix: "me"
        )
        self.meNav = meNav
        // 将页面添加到 tabBarController
        self.viewControllers = [growNav, shopNav, meNav]

        // 自定义标签栏的外观
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = .appMainGreen
            appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = .appMainGreen
            // 解决底部tabbar变透明的问题
            appearance.backgroundColor = .appMainWhite

            tabBar.tintColor = .appMainGreen
            tabBar.isTranslucent = false
            // 标准样式设置
            tabBar.standardAppearance = appearance
            // 滚动边缘样式设置
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
    }

    // MARK: - Bind Method
    private let mViewModel = TabbarViewModel()
    private func bindViewModel() {
        // 更新个人中心角标展示
        mViewModel.respUnreadMessageCountSubject
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { weakself, messageCount in
                guard messageCount > 0 else {
                    return
                }
                weakself.meNav?.tabBarItem.badgeValue = "\(messageCount)"
            }
            .disposed(by: mDisposeBag)
    }

    // MARK: - Private Method
    /// 打印一下当前版本号
    private func showBuildVersion() {
        let infoDic = Bundle.main.infoDictionary
        if let version = infoDic?["CFBundleShortVersionString"] as? String,
           let build = infoDic?["CFBundleVersion"] as? String {
            print("✈️ 当前应用 Version:\(version) Build:\(build)")
        }
    }

    /// 创建子视图
    private func createSubNav(title: String, classType: UIViewController.Type, imagePrefix: String) -> UINavigationController {
        // 创建页面
        let vc = classType.init()
        vc.hidesBottomBarWhenPushed = false
        vc.title = title

        // 更新图标
        let normalName = "tabbar_icon_" + imagePrefix + "_nor"
        let selectName = "tabbar_icon_" + imagePrefix + "_sel"
        vc.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: normalName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectName)?.withRenderingMode(.alwaysOriginal)
        )

        // 更新字体样式
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textTipsGray, // 未选中时的字体颜色
            .font: UIFont(style: .ABCDiatypeBold, size: 12) as Any // 未选中时的字体样式
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appMainGreen, // 选中时的字体颜色
            .font: UIFont(style: .ABCDiatypeRegular, size: 12) as Any // 选中时的字体样式
        ]
        vc.tabBarItem.setTitleTextAttributes(normalTextAttributes, for: .normal)
        vc.tabBarItem.setTitleTextAttributes(selectedTextAttributes, for: .selected)

        let nav = VSNavigationController(rootViewController: vc)
        return nav
    }

    /// 请求初始化信息接口
    private func makeInitRequest() {
        mViewModel.requestInitInfo()
        mViewModel.requestGlobalConfig()
        mViewModel.requestMessageConfig()

        // 刷新个人中心角标
        if VSUserInfoManager.shared.isLogin {
            mViewModel.requestMessageUnreadCount()
        }
    }

    /// 处理推出登录页的通知
    @objc private func notification(_: Notification) {
    }
}
