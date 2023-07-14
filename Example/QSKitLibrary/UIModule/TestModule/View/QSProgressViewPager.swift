//
//  QSProgressViewPager.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import UIKit
import QSKitLibrary

class QSProgressViewPager: QSView {
    // MARK: - Property
    /// 因为UIPageViewController需要添加在父级UIView Controller才工作
    private weak var mViewController: UIViewController?
    /// 下方气泡展示视图
    private var mBubbleControllers: [QSViewPagerBubbleController] = []

    var mDataSource: [String] = []

    var currentIndex: Int = 0 {
        didSet {
            self.updateSelectedStatus()
        }
    }

    // MARK: - Init / Public Method
    convenience init(
        controller: UIViewController?,
        stageList: [String],
        currentStage: String?
    ) {
        self.init(frame: .zero)

        self.mDataSource = stageList
        self.mViewController = controller

        self.createPageController()
        if let currentStage, let selectIndex = stageList.firstIndex(of: currentStage) {
            self.currentIndex = selectIndex
        } else {
            self.currentIndex = 0
        }
        self.reloadData()
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        self.addSubview(progressBar)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }
    }

    /// 默认创建一页气泡
    private func createPageController() {
        guard let parentViewController = self.mViewController else {
            return
        }
        // 创建初始的 BubbleViewController
        let initialViewController = createBubbleViewController(index: 0)
        self.mBubbleControllers = [initialViewController]

        // 将初始视图控制器添加到 pageViewController
        self.bubblesPageController.setViewControllers(
            [initialViewController],
            direction: .forward,
            animated: true,
            completion: nil
        )
        // 将 pageViewController 添加到视图层次结构中
        parentViewController.addChildViewController(self.bubblesPageController)
        self.addSubview(bubblesPageController.view)
        bubblesPageController.didMove(toParentViewController: parentViewController)

        // 布局
        bubblesPageController.view.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(155)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    /// 创建指定索引的 BubbleViewController
    private func createBubbleViewController(index: Int) -> QSViewPagerBubbleController {
        // 创建和配置 BubbleViewController 实例
        let bubbleViewController = QSViewPagerBubbleController()
        // 设置相应的内容
        // ...
        return bubbleViewController
    }

    /// 刷新数据源，重载气泡视图数量
    private func reloadData(){
        DispatchQueue.main.async {
            var pages: [QSViewPagerBubbleController] = []
            self.mDataSource.enumerated().forEach { (index, model) in
                let page = self.createBubbleViewController(index: index)
                pages.append(page)
            }

            self.mBubbleControllers = pages
        }
    }

    /// 更新选中状态
    private func updateSelectedStatus() {
        self.progressBar.reloadData()
    }

    // MARK: - Lazy Method
    private let kItemId = "QSViewPagerIndicatorItem"
    private let kItemSpace: CGFloat = 3.0
    /// 上方的进度条区域
    private lazy var progressBar: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = kItemSpace
        flowLayout.minimumInteritemSpacing = kItemSpace // 同行两横条间距

        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectView.backgroundColor = UIColor.appMainClear
        collectView.delegate = self
        collectView.dataSource = self
        collectView.register(QSViewPagerIndicatorItem.self, forCellWithReuseIdentifier: kItemId)
        return collectView
    }()

    /// 下方的详情气泡
    private lazy var bubblesPageController: UIPageViewController = {
        let _pagerView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        _pagerView.dataSource = self
        _pagerView.delegate = self
        return _pagerView
    }()
}

extension QSProgressViewPager: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: kItemId, for: indexPath) as? QSViewPagerIndicatorItem else {
            return UICollectionViewCell()
        }

        var itemStatus: QSViewPagerIndicatorItem.Status
        if indexPath.item < currentIndex {
            itemStatus = .before
        } else if indexPath.item == currentIndex {
            itemStatus = .current
        } else {
            itemStatus = .after
        }

        var itemLocation: QSViewPagerIndicatorItem.Location
        if indexPath.item == 0 {
            itemLocation = .first
        } else if indexPath.item == mDataSource.count - 1 {
            itemLocation = .last
        } else {
            itemLocation = .center
        }

        item.loadItem(
            stageName: mDataSource[indexPath.row],
            location: itemLocation,
            status: itemStatus
        )

        return item
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard mDataSource.count > 1 else { return .zero}

        // 宽度等于屏幕总宽，除去分界线后，等分
        let totalWidth = collectionView.bounds.width - (kItemSpace * CGFloat(mDataSource.count - 1))
        let itemWidth = totalWidth / CGFloat(mDataSource.count)
        let itemHeight = 30.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension QSProgressViewPager: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    /// 返回前一个 BubbleViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = mBubbleControllers.firstIndex(of: viewController as! QSViewPagerBubbleController),
              currentIndex > 0 else {
            return nil
        }
        return mBubbleControllers[currentIndex - 1]
    }

    /// 返回后一个 BubbleViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = mBubbleControllers.firstIndex(of: viewController as! QSViewPagerBubbleController),
              currentIndex < mBubbleControllers.count - 1 else {
            return nil
        }
        return mBubbleControllers[currentIndex + 1]
    }

    /// 返回页面数量(不实现则隐藏圆点，实现则展示圆点数量)
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return mBubbleControllers.count
//    }

    /// 返回当前页面索引
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first as? QSViewPagerBubbleController else {
            return 0
        }
        return mBubbleControllers.firstIndex(of: currentViewController) ?? 0
    }

}
