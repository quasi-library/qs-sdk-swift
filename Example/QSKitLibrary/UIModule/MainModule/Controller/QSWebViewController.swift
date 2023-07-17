//
//  QSWebViewController.swift
//  QuasiDemo
//
//  Created by Soul on 2022/1/27.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//
//  app内加载webview的基类Controller

import UIKit
import WebKit
import QSKitLibrary

/// 加载进度条
let estimatedProgressKeyPath = "estimatedProgress"
/// 动态更新标题
let titleKeyPath = "title"
/// 缓存页面Cookies
let cookieKey = "Cookie"
/// 指定空页面
let vsBlankUrl = "https://Quasi.com/404.html"

/**
 * 预设顶部菜单栏按钮样式
 */
public enum WebBarButtonItemType {
    case back
    case forward
    case reload
    case stop
    case activity
    case done
    case flexibleSpace
}

/**
 * 添加Item的位置
 */
public enum WebNavigationBarPosition {
    case none
    case left
    case right
}

/**
 * 枚举ViewController的展示样式 present / push
 */
public enum WebNavigationWay {
    case browser
    case push
}

/**
 * 枚举NavigationBar按钮点击事件
 */
@objc public enum WebNavigationType: Int {
    case linkActivated
    case formSubmitted
    case backForward
    case reload
    case formResubmitted
    case other
}

@objc public protocol VSWebViewControllerDelegate {
    @objc optional func QSWebViewController(_ controller: QSWebViewController, canDismiss url: URL) -> Bool
    @objc optional func QSWebViewController(_ controller: QSWebViewController, didStart url: URL)
    @objc optional func QSWebViewController(_ controller: QSWebViewController, didFinish url: URL)
    @objc optional func QSWebViewController(_ controller: QSWebViewController, didFail url: URL, withError error: Error)
    @objc optional func QSWebViewController(_ controller: QSWebViewController, decidePolicy url: URL, navigationType: WebNavigationType) -> Bool
    @objc optional func QSWebViewController(_ controller: QSWebViewController, decidePolicy url: URL, response: URLResponse) -> Bool
    @objc optional func initPushedVSWebViewController(url: URL) -> QSWebViewController
}

@objc public protocol VSWebViewControllerScrollViewDelegate {
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
}

/**
 * 通用的webview加载页面
 * 0. 通过便利构造器直接传入枚举的Path，根据不同环境自动配置域名，适用于内嵌的H5页面
 * 1. 可以通过默认构造器init之后更新url属性，适用于活动配置的H5页面，需要传入完整的http链接
 */
public class QSWebViewController: UIViewController {
    open var url: URL?
    private var userAgent: String? // 自定义UA,会在浏览器默认的基础上追加
    open var disableZoom = false
    open var navigationWay = WebNavigationWay.browser
    open var pullToRefresh = false
    open var urlsHandledByApp = [
        "hosts": ["itunes.apple.com"],
        "schemes": ["tel", "mailto", "sms"],
        "_blank": true
    ] as [String: Any]

    @available(iOS, obsoleted: 1.12.0, renamed: "defaultCookies")
    open var cookies: [HTTPCookie]?

    open var defaultCookies: [HTTPCookie]? {
        didSet {
            var shouldReload = (defaultCookies != nil && oldValue == nil) || (defaultCookies == nil && oldValue != nil)
            if let defaultCookies = defaultCookies, let oldValue = oldValue, defaultCookies != oldValue {
                shouldReload = true
            }
            if shouldReload, let url = url {
                load(url)
            }
        }
    }

    @available(iOS, obsoleted: 1.12.0, renamed: "defaultHeaders")
    open var headers: [String: String]?

    open var defaultHeaders: [String: String]? {
        didSet {
            var shouldReload = (defaultHeaders != nil && oldValue == nil) || (defaultHeaders == nil && oldValue != nil)
            if let defaultHeaders = defaultHeaders, let oldValue = oldValue, defaultHeaders != oldValue {
                shouldReload = true
            }
            if shouldReload, let url = url {
                load(url)
            }
        }
    }

    open var delegate: VSWebViewControllerDelegate?
    open var scrollViewDelegate: VSWebViewControllerScrollViewDelegate?

    open var tintColor: UIColor?
    open var websiteTitleInNavigationBar = true
    private var doneBarButtonItemPosition: WebNavigationBarPosition = .right
    // 配置左侧展示的Item（默认返回原生页面，如重写成返回返回web内上级页面则改为.back）
    open var leftNavigaionBarItemTypes: [WebBarButtonItemType] = []
//    open var leftNavigaionBarItemTypes: [WebBarButtonItemType] = [.back]
    // 配置右侧展示的Item
    open var rightNavigaionBarItemTypes: [WebBarButtonItemType] = []
    // 按照弹性间隔平铺的Item
    open var toolbarItemTypes: [WebBarButtonItemType] = [.forward, .reload, .activity]

    private var webView: WKWebView?

    private var previousNavigationBarState: (tintColor: UIColor?, hidden: Bool) = (nil, false)
    private var previousToolbarState: (tintColor: UIColor?, hidden: Bool) = (nil, true)

    private var lastTapPosition = CGPoint(x: 0, y: 0)

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.alpha = 1
        progressView.trackTintColor = UIColor(white: 1, alpha: 0)
        return progressView
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let activityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityIndicatorView.color = tintColor ?? .label
            return activityIndicatorView
        } else {
            let activityIndicatorView = UIActivityIndicatorView(style: .gray)
            activityIndicatorView.color = tintColor ?? .darkText
            return activityIndicatorView
        }
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(sender:)), for: UIControl.Event.valueChanged)
        webView?.scrollView.addSubview(refreshControl)
        webView?.scrollView.bounces = true
        return refreshControl
    }()

    private lazy var backBarButtonItem: UIBarButtonItem = {
        let bundle = Bundle(for: QSWebViewController.self)
        let backImage = UIImage(
            named: "nav_icon_back_black",
            in: bundle,
            compatibleWith: nil
        )
        return UIBarButtonItem(
            image: backImage?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(backDidClick(sender:))
        )
    }()

    private lazy var forwardBarButtonItem: UIBarButtonItem = {
        let bundle = Bundle(for: QSWebViewController.self)
        let forwardImage = UIImage(
            named: "nav_icon_forward_black",
            in: bundle,
            compatibleWith: nil)
        return UIBarButtonItem(
            image: forwardImage?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(forwardDidClick(sender:)))
    }()

    private lazy var reloadBarButtonItem: UIBarButtonItem = .init(
        barButtonSystemItem: .refresh,
        target: self,
        action: #selector(reloadDidClick(sender:))
    )

    private lazy var stopBarButtonItem: UIBarButtonItem = .init(
        barButtonSystemItem: .stop,
        target: self,
        action: #selector(stopDidClick(sender:))
    )

    private lazy var activityBarButtonItem: UIBarButtonItem = .init(
        barButtonSystemItem: .action,
        target: self,
        action: #selector(activityDidClick(sender:))
    )

    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let bundle = Bundle(for: QSWebViewController.self)
        let closeImage = UIImage(
            named: "nav_icon_close_black",
            in: bundle,
            compatibleWith: nil)
        return UIBarButtonItem(
            image: closeImage?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(doneDidClick(sender:))
        )
    }()

    private lazy var flexibleSpaceBarButtonItem: UIBarButtonItem = .init(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil
    )

    // MARK: - Init Method
    public convenience init(_ QSWebViewController: QSWebViewController) {
        self.init()
        userAgent = QSWebViewController.userAgent
        disableZoom = QSWebViewController.disableZoom
        navigationWay = QSWebViewController.navigationWay
        pullToRefresh = QSWebViewController.pullToRefresh
        urlsHandledByApp = QSWebViewController.urlsHandledByApp
        defaultCookies = QSWebViewController.defaultCookies
        defaultHeaders = QSWebViewController.defaultHeaders
        tintColor = QSWebViewController.tintColor
        websiteTitleInNavigationBar = QSWebViewController.websiteTitleInNavigationBar
        doneBarButtonItemPosition = QSWebViewController.doneBarButtonItemPosition
        leftNavigaionBarItemTypes = QSWebViewController.leftNavigaionBarItemTypes
        rightNavigaionBarItemTypes = QSWebViewController.rightNavigaionBarItemTypes
        toolbarItemTypes = QSWebViewController.toolbarItemTypes
        delegate = QSWebViewController.delegate
    }

    /**
     * 推荐初始化方法，可将vs相关path传入，然后根据不同环境配置host
     */
    public convenience init(_ vsPath: VSWebPath) {
        self.init()

    #if DEBUG
        var host: QSWebDomain
        switch QS_API_HOST {
        case QSApi.Host.Product.rawValue:
            host = QSWebDomain.WEB_DOMAIN_PRODUCT
        case QSApi.Host.PreRelease.rawValue:
            host = QSWebDomain.WEB_DOMAIN_PRE_RELEASE
        default:
            host = QSWebDomain.WEB_DOMAIN_TEST
        }
    #else
        let host = QSWebDomain.WEB_DOMAIN_PRODUCT
    #endif

        let url = URL(string: host.rawValue + vsPath.rawValue)
        self.url = url
    }

    /**
     * 推荐初始化方法，可将vs相关path传入，然后根据不同环境配置host
     */
    public convenience init(_ customUrl: String) {
        self.init()

    #if DEBUG
        var host: QSWebDomain
        switch QS_API_HOST {
        case QSApi.Host.Product.rawValue:
            host = QSWebDomain.WEB_DOMAIN_PRODUCT
        case QSApi.Host.PreRelease.rawValue:
            host = QSWebDomain.WEB_DOMAIN_PRE_RELEASE
        default:
            host = QSWebDomain.WEB_DOMAIN_TEST
        }
    #else
        let host = QSWebDomain.WEB_DOMAIN_PRODUCT
    #endif

        if customUrl.hasPrefix("http://") || customUrl.hasPrefix("https://") {
            self.url = URL(string: customUrl)
        } else {
            self.url = URL(string: host.rawValue + customUrl)
        }
    }

    deinit {
        webView?.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
        webView?.removeObserver(self, forKeyPath: titleKeyPath)

        webView?.scrollView.delegate = nil
    }

    // MARK: - Lifecycle Method

    /**
     加载视图，后续可添加自定义UserAgaent 和 Header这些
     */
    override open func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        if #available(iOS 13.0, *) {
            webView.backgroundColor = .systemBackground
        }

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self

        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true

        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: titleKeyPath, options: .new, context: nil)

        view = webView
        self.webView = webView
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = navigationItem.title ?? url?.absoluteString

        if let currentNavigationController = currentNavigationController {
            previousNavigationBarState = (currentNavigationController.navigationBar.tintColor, currentNavigationController.navigationBar.isHidden)
            previousToolbarState = (currentNavigationController.toolbar.tintColor, currentNavigationController.toolbar.isHidden)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(webViewDidTap(sender:)))
        tapGesture.delegate = self
        webView?.addGestureRecognizer(tapGesture)

        updateProgressViewFrame()
        addBarButtonItems()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.updateNavigationBarStyle()

        // 定义与h5约定的userAgent，传入app标识用于去掉h5的双重导航栏等
        let appVersion: String = "sn-App Quasi \(VSMobileInfo.bundleVersion)"
        let appLoginToken: String = ""
        userAgent = appVersion + appLoginToken

        if let userAgent = userAgent {
            webView?.evaluateJavaScript("navigator.userAgent") { [weak self] result, error in
                guard let weakSelf = self else {
                    return
                }

                defer {
                    if let url = weakSelf.url {
                        weakSelf.load(url)
                    }
                }

                guard error == nil, let originalUserAgent = result as? String else {
                    weakSelf.webView?.customUserAgent = userAgent
                    return
                }

                weakSelf.webView?.customUserAgent = String(format: "%@ %@", originalUserAgent, userAgent)
            }
        } else if let url = url {
            load(url)
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController?.navigationBar {
            navBar.isHidden = false
        }
        setUpState()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        rollbackState()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case estimatedProgressKeyPath?:
            guard let estimatedProgress = webView?.estimatedProgress else {
                return
            }

            if currentNavigationController?.isNavigationBarHidden ?? true, activityIndicatorView.isDescendant(of: view) {
                if estimatedProgress >= 1.0 {
                    activityIndicatorView.stopAnimating()
                } else {
                    activityIndicatorView.startAnimating()
                }
            } else if let navigationItem = currentNavigationController?.navigationBar, progressView.isDescendant(of: navigationItem) {
                progressView.alpha = 1
                progressView.setProgress(Float(estimatedProgress), animated: true)

                if estimatedProgress >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                        self.progressView.alpha = 0
                    }, completion: { _ in
                        self.progressView.setProgress(0, animated: false)
                    })
                }
            }
        case titleKeyPath?:
            if websiteTitleInNavigationBar || URL(string: navigationItem.title ?? "")?.appendingPathComponent("") == url?.appendingPathComponent("") {
                navigationItem.title = webView?.title
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    // Reference: https://medium.com/swlh/popover-menu-over-cards-containing-webkit-views-on-ios-13-a16705aff8af
    // https://stackoverflow.com/questions/58164583/wkwebview-with-the-new-ios13-modal-crash-when-a-file-picker-is-invoked
    override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        setUIDocumentMenuViewControllerSoureViewsIfNeeded(viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override open func targetViewController(forAction _: Selector, sender _: Any?) -> UIViewController? {
        currentNavigationController
    }

    // MARK: - UI Layout Method
      /// 更新导航栏风格（白底黑字/黑底绿字）
    private func updateNavigationBarStyle() {
        /// 设置导航栏背景色 / 标题颜色
        let barColor = UIColor.appBackgroundPage
        let textColor = UIColor.textMainBlack

        /// 渲染到导航栏
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = barColor
            appearance.shadowImage = UIImage(color: barColor)
            let font = UIFont(style: .ABCDiatypeBold, size: 16)
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: font as Any,
                NSAttributedString.Key.kern: 0.5
            ]

            if let bar = self.navigationController?.navigationBar {
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = bar.standardAppearance
                bar.barTintColor = textColor
                bar.tintColor = textColor
                bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                bar.shadowImage = UIImage()
            }
        }
    }
}

// MARK: - Public Methods

public extension QSWebViewController {
    func load(_ url: URL) {
        guard let webView = webView else {
            return
        }
        let request = createRequest(url: url)
        DispatchQueue.main.async {
            webView.load(request)
        }
    }

    func load(htmlString: String, baseURL: URL?) {
        DispatchQueue.main.async {
            self.webView?.loadHTMLString(htmlString, baseURL: baseURL)
        }
    }

    func goBackToFirstPage() {
        if let firstPageItem = webView?.backForwardList.backList.first {
            webView?.go(to: firstPageItem)
        }
    }

    func clearCache(completionHandler: @escaping () -> Void) {
        var websiteDataTypes = Set<String>([WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeOfflineWebApplicationCache])
        if #available(iOS 11.3, *) {
            websiteDataTypes.insert(WKWebsiteDataTypeFetchCache)
        }
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: completionHandler)
    }

    func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView?.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }

    func loadBlankPage() {
        guard let url = URL(string: "about:blank") else {
            return
        }
        self.url = url
        load(url)
    }

    func setUIDocumentMenuViewControllerSoureViewsIfNeeded(_ viewControllerToPresent: UIViewController) {
        viewControllerToPresent.popoverPresentationController?.sourceView = view
        if lastTapPosition == .zero {
            lastTapPosition = view.center
        }
        viewControllerToPresent.popoverPresentationController?.sourceRect = CGRect(origin: lastTapPosition, size: CGSize(width: 0, height: 0))
    }

    func reload() {
        webView?.stopLoading()
        if let url = webView?.url, !isBlank(url: url) {
            webView?.reload()
        } else if let url = url {
            load(url)
        }
    }

    func pushWebViewController(url: URL) {
        let QSWebViewController = delegate?.initPushedVSWebViewController?(url: url) ?? QSWebViewController(self)
        QSWebViewController.url = url
        show(QSWebViewController, sender: self)
        setUpState()
    }
}

// MARK: - private Methods

private extension QSWebViewController {
    var availableCookies: [HTTPCookie]? {
        defaultCookies?.filter { cookie in
            var result = true
            if let host = url?.host, !cookie.domain.hasSuffix(host) {
                result = false
            }
            if cookie.isSecure, url?.scheme != "https" {
                result = false
            }

            return result
        }
    }

    var currentNavigationController: UINavigationController? {
        navigationController ?? parent?.navigationController ?? parent?.presentingViewController?.navigationController
    }

    func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        // Set up Headers
        if let defaultHeaders = defaultHeaders {
            for (field, value) in defaultHeaders {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }

        // Set up Cookies
        if let cookies = availableCookies, let value = HTTPCookie.requestHeaderFields(with: cookies)[cookieKey] {
            request.addValue(value, forHTTPHeaderField: cookieKey)
        }

        return request
    }

    func updateProgressViewFrame() {
        guard let navigationBar = currentNavigationController?.navigationBar, progressView.isDescendant(of: navigationBar) else {
            return
        }

        let navigationBarHeight = navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // 判断导航栏更新一下进度条位置
        progressView.frame = CGRect(
            x: 0,
            y: navigationBarHeight - progressView.frame.size.height,
            width: navigationBar.frame.size.width,
            height: progressView.frame.size.height
        )

        // 判断导航栏更新一下网页位置
        webView?.frame = CGRect(
            x: 0,
            y: navigationBarHeight + statusBarHeight,
            width: navigationBar.frame.size.width,
            height: (webView?.frame.size.height ?? kScreenHeight) - navigationBarHeight - statusBarHeight
        )
    }

    func addBarButtonItems() {
        let barButtonItems: [WebBarButtonItemType: UIBarButtonItem] = [
            .back: backBarButtonItem,
            .forward: forwardBarButtonItem,
            .reload: reloadBarButtonItem,
            .stop: stopBarButtonItem,
            .activity: activityBarButtonItem,
            .done: doneBarButtonItem,
            .flexibleSpace: flexibleSpaceBarButtonItem
        ]

        if presentingViewController != nil {
            switch doneBarButtonItemPosition {
            case .left:
                if !leftNavigaionBarItemTypes.contains(.done) {
                    leftNavigaionBarItemTypes.insert(.done, at: 0)
                }
            case .right:
                if !rightNavigaionBarItemTypes.contains(.done) {
                    rightNavigaionBarItemTypes.insert(.done, at: 0)
                }
            case .none:
                if !rightNavigaionBarItemTypes.contains(.done) {
                    rightNavigaionBarItemTypes.insert(.done, at: 0)
                }
            }
        }

        navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems ?? [] + leftNavigaionBarItemTypes.map {  barButtonItemType in
            if let barButtonItem = barButtonItems[barButtonItemType] {
                return barButtonItem
            }
            return UIBarButtonItem()
        }

        navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems ?? [] + rightNavigaionBarItemTypes.map { barButtonItemType in
            if let barButtonItem = barButtonItems[barButtonItemType] {
                return barButtonItem
            }
            return UIBarButtonItem()
        }

        if toolbarItemTypes.isEmpty == false {
            for index in 0 ..< toolbarItemTypes.count - 1 {
                toolbarItemTypes.insert(.flexibleSpace, at: 2 * index + 1)
            }
        }

        setToolbarItems(
            toolbarItemTypes.map { barButtonItemType -> UIBarButtonItem in
            if let barButtonItem = barButtonItems[barButtonItemType] {
                return barButtonItem
            }
            return UIBarButtonItem()
            },
            animated: true)
    }

    func updateBarButtonItems() {
        backBarButtonItem.isEnabled = webView?.canGoBack ?? false
        forwardBarButtonItem.isEnabled = webView?.canGoForward ?? false

        let updateReloadBarButtonItem: (UIBarButtonItem, Bool) -> UIBarButtonItem = { [unowned self] barButtonItem, isLoading in
                switch barButtonItem {
                case self.reloadBarButtonItem, self.stopBarButtonItem:
                    return isLoading ? self.stopBarButtonItem : self.reloadBarButtonItem
                default:
                    break
                }
                return barButtonItem
        }

        let isLoading = webView?.isLoading ?? false
        toolbarItems = toolbarItems?.map { barButtonItem -> UIBarButtonItem in
            updateReloadBarButtonItem(barButtonItem, isLoading)
        }

        navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems?.map { barButtonItem -> UIBarButtonItem in
            updateReloadBarButtonItem(barButtonItem, isLoading)
        }

        navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems?.map { barButtonItem -> UIBarButtonItem in
            updateReloadBarButtonItem(barButtonItem, isLoading)
        }
    }

    func setUpState() {
        var numNavigationItems = 0
        if let leftBarButtonItems = navigationItem.leftBarButtonItems {
            numNavigationItems += leftBarButtonItems.count
        }
        if let rightBarButtonItems = navigationItem.rightBarButtonItems {
            numNavigationItems += rightBarButtonItems.count
        }
        if currentNavigationController?.viewControllers.count ?? 1 > 1 {
            numNavigationItems += 1
        }

        if let tintColor = tintColor {
            progressView.progressTintColor = tintColor
            currentNavigationController?.navigationBar.tintColor = tintColor
            currentNavigationController?.toolbar.tintColor = tintColor
        }

        if currentNavigationController?.isNavigationBarHidden ?? true, !activityIndicatorView.isDescendant(of: view) {
            activityIndicatorView.center = view.center
            view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        } else if let navigationBar = currentNavigationController?.navigationBar, !progressView.isDescendant(of: navigationBar) {
            navigationBar.addSubview(progressView)
        }
    }

    func rollbackState() {
        progressView.removeFromSuperview()

        if let tintColor = previousNavigationBarState.tintColor {
            currentNavigationController?.navigationBar.tintColor = tintColor
        }
        if let tintColor = previousToolbarState.tintColor {
            currentNavigationController?.toolbar.tintColor = tintColor
        }

        currentNavigationController?.setToolbarHidden(previousToolbarState.hidden, animated: true)
        currentNavigationController?.setNavigationBarHidden(previousNavigationBarState.hidden, animated: true)
    }

    func checkRequestCookies(_ request: URLRequest, cookies: [HTTPCookie]) -> Bool {
        if cookies.isEmpty {
            return true
        }
        guard let headerFields = request.allHTTPHeaderFields, let cookieString = headerFields[cookieKey] else {
            return false
        }

        let requestCookies = cookieString.components(separatedBy: ";").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "=", maxSplits: 1).map(String.init)
        }

        var valid = false
        for cookie in cookies {
            valid = requestCookies.filter {
                $0[0] == cookie.name && $0[1] == cookie.value
            }.isEmpty == false
            if !valid {
                break
            }
        }
        return valid
    }

    func openURLWithApp(_ url: URL) async -> Bool {
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            return await application.open(url)
        }

        return false
    }

    func handleURLWithApp(_ url: URL, targetFrame: WKFrameInfo?) async -> Bool {
        let hosts = urlsHandledByApp["hosts"] as? [String]
        let schemes = urlsHandledByApp["schemes"] as? [String]
        let blank = urlsHandledByApp["_blank"] as? Bool

        var tryToOpenURLWithApp = false
        if let host = url.host, hosts?.contains(host) ?? false {
            tryToOpenURLWithApp = true
        }
        if let scheme = url.scheme, schemes?.contains(scheme) ?? false {
            tryToOpenURLWithApp = true
        }
        if blank ?? false, targetFrame == nil {
            tryToOpenURLWithApp = true
        }

        return await tryToOpenURLWithApp ? openURLWithApp(url) : false
    }

    func isBlank(url: URL) -> Bool {
        url.absoluteString == "about:blank"
    }
}

// MARK: - WKUIDelegate

extension QSWebViewController: WKUIDelegate {}

// MARK: - WKNavigationDelegate

extension QSWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if let url = webView.url {
            if !isBlank(url: url) {
                self.url = url
            }
            delegate?.QSWebViewController?(self, didStart: url)
        }
    }

    public func webView(_ webView: WKWebView, didFinish _: WKNavigation) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if pullToRefresh {
            refreshControl.endRefreshing()
        }
        if let url = webView.url {
            if !isBlank(url: url) {
                self.url = url
            }
            delegate?.QSWebViewController?(self, didFinish: url)
        }
    }

    public func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation, withError error: Error) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if pullToRefresh {
            refreshControl.endRefreshing()
        }
        if let url = url {
            delegate?.QSWebViewController?(self, didFail: url, withError: error)
        }
    }

    public func webView(_: WKWebView, didFail _: WKNavigation, withError error: Error) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if pullToRefresh {
            refreshControl.endRefreshing()
        }
        if let url = url {
            delegate?.QSWebViewController?(self, didFail: url, withError: error)
        }
    }

    public func webView(_: WKWebView, didReceive _: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }

    public func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) async {
        var actionPolicy: WKNavigationActionPolicy = .allow
        defer {
            decisionHandler(actionPolicy)
        }
        guard let url = navigationAction.request.url, !url.isFileURL else {
            return
        }

        if let targetFrame = navigationAction.targetFrame, !targetFrame.isMainFrame {
            return
        }

        if await handleURLWithApp(url, targetFrame: navigationAction.targetFrame) {
            actionPolicy = .cancel
            return
        }

        if let navigationType = WebNavigationType(rawValue: navigationAction.navigationType.rawValue),
            let result = delegate?.QSWebViewController?(self, decidePolicy: url, navigationType: navigationType) {
            actionPolicy = result ? .allow : .cancel
            if actionPolicy == .cancel {
                return
            }
        }

        switch navigationAction.navigationType {
        case .formSubmitted, .linkActivated:
            if let fragment = url.fragment {
                let removedFramgnetURL = URL(string: url.absoluteString.replacingOccurrences(of: "#\(fragment)", with: ""))
                if removedFramgnetURL == self.url {
                    return
                }
            }
            if navigationWay == .push {
                pushWebViewController(url: url)
                actionPolicy = .cancel
                return
            }
            fallthrough
        default:
            if navigationAction.targetFrame == nil {
                pushWebViewController(url: url)
                actionPolicy = .cancel
            }
        }
    }

    public func webView(_: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        var responsePolicy: WKNavigationResponsePolicy = .allow
        defer {
            decisionHandler(responsePolicy)
        }
        guard let url = navigationResponse.response.url, !url.isFileURL else {
            return
        }

        if let result = delegate?.QSWebViewController?(self, decidePolicy: url, response: navigationResponse.response) {
            responsePolicy = result ? .allow : .cancel
        }

        if navigationWay == .push,
            responsePolicy == .cancel,
            let webViewController = currentNavigationController?.topViewController as? QSWebViewController,
            webViewController.url?.appendingPathComponent("") == url.appendingPathComponent("") {
            currentNavigationController?.popViewController(animated: true)
        }
    }
}

extension QSWebViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        disableZoom ? nil : scrollView.subviews[0]
    }

    public func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        if pullToRefresh {
            refreshWebView(sender: refreshControl)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
}

extension QSWebViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - @objc

@objc extension QSWebViewController {
    func backDidClick(sender _: AnyObject) {
        webView?.goBack()
    }

    func forwardDidClick(sender _: AnyObject) {
        webView?.goForward()
    }

    func reloadDidClick(sender _: AnyObject) {
        reload()
    }

    func stopDidClick(sender _: AnyObject) {
        webView?.stopLoading()
    }

    func activityDidClick(sender _: AnyObject) {
        guard let url = url else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    func doneDidClick(sender _: AnyObject) {
        var canDismiss = true
        if let url = url {
            canDismiss = delegate?.QSWebViewController?(self, canDismiss: url) ?? true
        }
        if canDismiss {
            dismiss(animated: true, completion: nil)
        }
    }

    func refreshWebView(sender: UIRefreshControl) {
        let isLoading = webView?.isLoading ?? false
        if !isLoading {
            sender.beginRefreshing()
            reloadDidClick(sender: sender)
        }
    }

    func webViewDidTap(sender: UITapGestureRecognizer) {
        lastTapPosition = sender.location(in: view)
    }
}
