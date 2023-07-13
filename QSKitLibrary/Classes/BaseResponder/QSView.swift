//
//  VSView.swift
//  QuasiDemo
//
//  Created by Soul on 2023/5/8.
//  Copyright © 2023 Quasi Inc. All rights reserved.
//

import UIKit

public class QSView: UIView {
    // MARK: - Init Method
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubSnaps()
        layoutSnaps()
    }

    // MARK: - UI Layout Method
    internal func addSubSnaps() {
    }

    internal func layoutSnaps() {
    }
}
