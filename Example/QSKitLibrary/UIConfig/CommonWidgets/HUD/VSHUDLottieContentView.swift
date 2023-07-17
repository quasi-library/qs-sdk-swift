//
//  VSHUDLottieContentView.swift
//  QuasiDemo
//
//  Created by Geminy on 2022/5/5.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Lottie
import UIKit

class VSHUDLottieContentView: UIView {
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: sideLength, height: sideLength)
    }

    private var sideLength: CGFloat = 0.0

    public init(length: CGFloat, lottie: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: length, height: length))
        sideLength = length

        let animationView = LottieAnimationView(name: lottie)

//        let animationView = AnimationView(name: lottie)
        animationView.play(completion: nil)
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.frame = CGRect(x: 0, y: 0, width: length, height: length)

        self.addSubview(animationView)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
