//
//  QSBaseViewController.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2022/1/6.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

@objc open class QSBaseViewController: UIViewController {
    // MARK: - LifeCycle Method
    internal let mDisposeBag = DisposeBag()
    deinit {
        debugPrint(self, "🦁️ dealloc 已释放")
    }

    public init() {
      super.init(nibName: nil, bundle: nil)

      self.hidesBottomBarWhenPushed = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.hidesBottomBarWhenPushed = true
    }

    /// 拆分首次加载视图执行ViewDidLoad时的方法，供子类覆写
    override open func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(self, "🦁️ viewDidLoad 已加载")

        // 1. 初始化ViewModel并监听数据回调
        bindViewModel()

        // 2. 添加并布局UI组件
        addSubSnaps()
        layoutSnaps()

        // 3. 子类中执行网络请求等

    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 默认展示导航栏，特殊页面复写
        // self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // MARK: - Bind Method
    func bindViewModel () {
//        _ = mViewModel.errorDataSubject.subscribe { errMessage in
//             VSShowNewHUD.dismiss()
//             VSShowNewHUD.showText(errMessage)
//        }
    }

    // MARK: - UI Layout Method

    /// 重写状态栏风格
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    /// 枚举导航栏配色风格
    enum VSNavigationBarStyle {
        case whiteBackgroundBlackText /// 白底黑字
        case whiteBackgroundGreenText /// 白底绿字
        case blackBackgroundGreenText /// 黑底绿字
        case blackBackgroundWhiteText /// 黑底白字
        case clearBackgroundBlackText /// 透明底黑字
        case clearBackgroundWhiteText /// 透明底白字
    }

    /**
     更新导航栏风格（白底黑字/黑底绿字）
     */
    func updateNavigationBarStyle(_ style: VSNavigationBarStyle) {
        /// 设置导航栏背景色 / 标题颜色
        var barColor = UIColor.white
        var textColor = UIColor.black

        switch style {
        case .whiteBackgroundBlackText:
            barColor = UIColor.appBackgroundPage
            textColor = UIColor.black
        case .whiteBackgroundGreenText:
            barColor = UIColor.appBackgroundPage
            textColor = UIColor.appMainGreen
        case .blackBackgroundGreenText:
            barColor = UIColor.black
            textColor = UIColor.appMainGreen
        case .blackBackgroundWhiteText:
            barColor = UIColor.appMainBlack
            textColor = UIColor.appMainWhite
        case .clearBackgroundBlackText:
            barColor = UIColor.appMainClear
            textColor = UIColor.black
        case .clearBackgroundWhiteText:
            barColor = UIColor.appMainClear
            textColor = UIColor.appMainWhite
        }

        /// 渲染到导航栏
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = barColor
            appearance.shadowImage = generateImageWithColor(color: barColor)
            let font = VSStandardDesign.fontForStyle(.heading18Bold)
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: font as Any,
                NSAttributedString.Key.kern: 0.5
            ]

            if let bar = navigationController?.navigationBar {
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = bar.standardAppearance
                bar.barTintColor = textColor
                bar.tintColor = textColor
                bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                bar.shadowImage = UIImage()

//                bar.setBackgroundImage(generateImageWithColor(color: barColor), for: UIBarMetrics.default)
            }
        }
    }

    /**
     拆分ViewDidLoad方法，在基类中执行默认操作，并供子类复写“添加UI组件”
     */
    internal func addSubSnaps() {
        self.view.backgroundColor = UIColor.appBackgroundPage
        // 供子类添加initView和addSubView的方法
    }

    /**
     拆分ViewDidLoad方法，在基类中执行默认操作，并供子类复写“更新UI组件布局”
     */
    internal func layoutSnaps() {
        // 1. 更新导航栏
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // 导航栏 默认白底黑字
        updateNavigationBarStyle(.whiteBackgroundBlackText)
        // 导航栏返回按钮去除标题
        if #available(iOS 14.0, *) {
            self.navigationItem.backButtonDisplayMode = .minimal
        } else {
            self.navigationItem.backButtonTitle = ""
        }

        // 2.供子类追加snp相关方法
    }

    /**
     导航栏中添加自定义按钮
     */
    internal func addBarButtonItem(isLeft: Bool = true, imgName: String = "nav_icon_back_black", action: Selector) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named: imgName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = .appMainBlack
        let item = UIBarButtonItem(customView: button)
        if isLeft {
            if navigationItem.leftBarButtonItems?.isEmpty == false {
                navigationItem.leftBarButtonItems?.append(item)
            } else {
                navigationItem.leftBarButtonItems = [item]
            }
        } else {
            if let list = navigationItem.rightBarButtonItems, list.isEmpty == false {
                navigationItem.rightBarButtonItems?.append(item)
            } else {
                navigationItem.rightBarButtonItems = [item]
            }
        }
    }

    /// 是否支持自动转屏
    open override var shouldAutorotate: Bool {
        return false
    }

    /// 支持哪些屏幕方向
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    /// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // MARK: - Action Method
    /// 是否允许nav.backItem直接返回（子类若拦截事件可重写）
    public override func currentViewControllerShouldPop() -> Bool {
        return true
    }

    /**
     默认左上角的按钮是返回上一页，子类可以重写
     */
    @objc final func popToBack() {
        DispatchQueue.main.async {
            if self.navigationController?.topViewController == self {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    /**
     默认返回到页面栈底，方便子类调用
     */
    final func popToRoot() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    // MARK: - Private Method

    private func generateImageWithColor(color: UIColor) -> UIImage? {
        if color == UIColor.clear {
            return UIImage()
        }
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
