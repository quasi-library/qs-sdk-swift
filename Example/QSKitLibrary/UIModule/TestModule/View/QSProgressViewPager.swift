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
    /// 气泡间隔
    private let kBubbleSpace = 8.0

    /// 下方气泡展示视图
    private var mBubbleViews: [QSBubbleDialogView] = []

    var mDataSource: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }

    var currentIndex: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.updateSelectedStatus()
            }
        }
    }

    // MARK: - Init / Public Method
    convenience init(
        stageList: [String],
        currentStage: String?
    ) {
        self.init(frame: .zero)

        if let currentStage, let selectIndex = stageList.firstIndex(of: currentStage) {
            self.currentIndex = selectIndex
        } else {
            self.currentIndex = 0
        }

        self.mDataSource = {
            self.mDataSource = stageList
            return stageList
        }()
    }

    // MARK: - UI Layout Method
    override func addSubSnaps() {
        super.addSubSnaps()

        self.addSubview(progressBar)
        self.addSubview(bubblesScrollView)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }

        bubblesScrollView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(140)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    /// 创建指定索引的 BubbleViewController
    private func createBubbleView(index: Int) -> QSBubbleDialogView {
        let model = self.mDataSource[index]
        let bubbleView = QSBubbleDialogView(model)
        // 设置相应的内容
        bubbleView.refreashVertexPostion(sumBubbleCount: self.mDataSource.count, thisBubbleIndex: index)
        return bubbleView
    }

    /// 刷新数据源，重载气泡视图数量
    private func reloadData() {
        self.mBubbleViews.forEach { oldView in
            oldView.removeFromSuperview()
        }

        var newPages: [QSBubbleDialogView] = []
        var lastBubbleView: QSBubbleDialogView?
        self.mDataSource.enumerated().forEach { index, _ in
            let bubbleView = self.createBubbleView(index: index)
            newPages.append(bubbleView)

            self.bubblesScrollView.addSubview(bubbleView)
            bubbleView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
                if let lastBubbleView {
                    make.leading.equalTo(lastBubbleView.snp.trailing).offset(15)
                } else {
                    make.leading.equalToSuperview()
                }
                make.width.equalTo(self.snp.width).offset(-16 - kBubbleSpace - 16)
                if index == self.mDataSource.count - 1 {
                    make.trailing.equalToSuperview().offset(-16)
                }
            }
            lastBubbleView = bubbleView
        }

        self.setNeedsLayout()
        self.mBubbleViews = newPages
        self.updateSelectedStatus()
    }

    /// 更新选中状态
    private func updateSelectedStatus() {
        // 刷新进度条
        self.progressBar.reloadData()
        self.layoutIfNeeded()

        // 滑动到指定气泡
        guard self.currentIndex < self.mBubbleViews.count else { return }
        let showBubble = self.mBubbleViews[currentIndex]
        let showRect = CGRect(x: showBubble.mj_x, y: showBubble.mj_y, width: showBubble.mj_w + kBubbleSpace + 16, height: showBubble.mj_h)
        self.bubblesScrollView.scrollRectToVisible(showRect, animated: true)
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
    private lazy var bubblesScrollView: UIScrollView = {
        let _pagerView = UIScrollView()
//        _pagerView.backgroundColor = .systemGray
        _pagerView.showsHorizontalScrollIndicator = false
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndex = indexPath.item
    }
}

extension QSProgressViewPager: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var eachBubbleWidth: CGFloat = kScreenWidth - 16 * 2 - kBubbleSpace
        if let exsitBubble = mBubbleViews.first, exsitBubble.mj_w > 0 {
            eachBubbleWidth = exsitBubble.mj_w + kBubbleSpace
        }

        let currentPage = floor((scrollView.contentOffset.x + eachBubbleWidth * 0.5) / eachBubbleWidth)
        self.currentIndex = Int(currentPage)
    }
}
