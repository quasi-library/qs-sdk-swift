//
//  VSImageView.swift
//  QuasiDemo
//
//  Created by Soul on 2022/10/28.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import UIKit

public class QSImageView: UIImageView {
    // MARK: - Init Method
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(imageName: String) {
        let image = UIImage(named: imageName)
        super.init(image: image)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
