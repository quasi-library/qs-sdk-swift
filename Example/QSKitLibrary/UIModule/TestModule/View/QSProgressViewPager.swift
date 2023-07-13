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
    var mDataSource: [String] = []

    var currentIndex: Int = 0 {
        didSet {
            self.updateSelectedStatus()
        }
    }

    // MARK: - Init / Public Method
    convenience init(
        stageList: [String],
        currentStage: String?
    ) {
        self.init(frame: .zero)

        self.mDataSource = stageList
        if let currentStage, let selectIndex = stageList.firstIndex(of: currentStage) {
            self.currentIndex = selectIndex
        } else {
            self.currentIndex = 0
        }
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
            make.bottom.equalToSuperview()
        }
    }


    /// 更新选中状态
    private func updateSelectedStatus() {
        self.progressBar.reloadData()
    }

    // MARK: - Lazy Method
    private let kItemId = "QSViewPagerIndicatorItem"
    private let kItemSpace: CGFloat = 1.0
    private lazy var progressBar: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = kItemSpace
        flowLayout.minimumInteritemSpacing = kItemSpace // 同行两横条间距
//        flowLayout.itemSize = CGSize(width: 58, height: 86)

        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectView.backgroundColor = UIColor.appMainClear
        collectView.delegate = self
        collectView.dataSource = self
        collectView.register(QSViewPagerIndicatorItem.self, forCellWithReuseIdentifier: kItemId)
        return collectView
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

