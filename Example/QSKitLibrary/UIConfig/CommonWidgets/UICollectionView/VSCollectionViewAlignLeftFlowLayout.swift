//
//  VSCollectionViewAlignLeftFlowLayout.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/23.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

import UIKit

extension UICollectionViewLayoutAttributes {
    func alignLeftFrameWithSectionInset(_ sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

/// 防止CollectionView只有一个Cell时居中，所以自定义左对齐布局
/// - NOTE: 使用此UICollectionViewFlowLayout时记得设置调用方collectionView需要继承UICollectionViewFlowLayout协议
class VSCollectionViewAlignLeftFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes = originalAttributes
        originalAttributes?.forEach { attributes in
            if attributes.representedElementKind == nil {
                if let i = updatedAttributes?.firstIndex(of: attributes),
                let newLayoutAttribute = self.layoutAttributesForItem(at: attributes.indexPath) {
                    updatedAttributes?[i] = newLayoutAttribute
                }
            }
        }

        return updatedAttributes?.map { $0.copy() as! UICollectionViewLayoutAttributes }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let superLayoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy()
        guard let currentItemAttributes = superLayoutAttributes as? UICollectionViewLayoutAttributes else {
            return nil
        }
        let sectionInset = evaluatedSectionInsetForItem(at: indexPath.section)

        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = collectionView!.frame.size.width - sectionInset.left - sectionInset.right

        if isFirstItemInSection == true {
            currentItemAttributes.alignLeftFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }

        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousFrame = layoutAttributesForItem(at: previousIndexPath)!.frame
        let previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width
        let currentFrame = currentItemAttributes.frame
        let strecthedCurrentFrame = CGRect(
            x: sectionInset.left,
            y: currentFrame.origin.y,
            width: layoutWidth,
            height: currentFrame.size.height
        )


        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow == true {
            currentItemAttributes.alignLeftFrameWithSectionInset(sectionInset)
            return currentItemAttributes
        }

        var frame = currentItemAttributes.frame
        frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        currentItemAttributes.frame = frame
        return currentItemAttributes
    }

    func evaluatedMinimumInteritemSpacingForSection(at index: NSInteger) -> CGFloat {
        if let collectionView = self.collectionView,
           let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
           let spacing = delegate.collectionView?(
            collectionView,
            layout: self,
            minimumInteritemSpacingForSectionAt: index
           ) {
            return spacing
        } else {
            return minimumInteritemSpacing
        }
    }

    func evaluatedSectionInsetForItem(at index: NSInteger) -> UIEdgeInsets {
        if let collectionView = self.collectionView,
           let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
           let insets = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: index) {
            return insets
        } else {
            return sectionInset
        }
    }
}
