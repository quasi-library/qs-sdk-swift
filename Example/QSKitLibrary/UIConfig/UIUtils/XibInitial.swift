//
//  XibInitial.swift
//  QuasiDemo
//
//  Created by Gwyneth Gan on 2021/10/28.
//

import Foundation
import UIKit

/// 糟粕，待清理
open class XibInitial: UIView {
    private var xibContentView: UIView!

    open func initial() {}

    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    private func xibSetup() {
        if xibContentView != nil { return }
        xibContentView = nib
        xibContentView.frame.size = bounds.size
        // Make the view stretch with containing view
        xibContentView.translatesAutoresizingMaskIntoConstraints = true
        xibContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibContentView)
        initial()
    }

    var nib: UIView {
        let cls = type(of: self)
        let bundle = Bundle(for: cls)
        let nib = UINib(nibName: "\(cls)", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
