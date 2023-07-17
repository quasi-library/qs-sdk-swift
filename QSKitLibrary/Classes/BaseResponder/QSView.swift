//
//  VSView.swift
//  QuasiDemo
//
//  Created by Soul on 2023/5/8.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

open class QSView: UIView {
    // MARK: - Init Method
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubSnaps()
        layoutSnaps()
    }

    // MARK: - UI Layout Method
    open func addSubSnaps() {
    }

    open func layoutSnaps() {
    }
}
