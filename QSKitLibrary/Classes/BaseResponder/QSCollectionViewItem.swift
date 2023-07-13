//
//  QSCollectionViewItem.swift
//  QuasiDemo
//
//  Created by Soul on 2023/4/19.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

class QSCollectionViewItem: UICollectionViewCell {
    // MARK: - Init Method
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addSubSnaps()
        layoutSnaps()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubSnaps()
        layoutSnaps()
    }

    // MARK: - UI Layout Method
    func addSubSnaps() {
    }

    func layoutSnaps() {
    }
}
