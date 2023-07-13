//
//  ExampleDoubleSliderController.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2022/10/13.
//  Copyright © 2022 Quasi Team. All rights reserved.
//

import UIKit
import QSKitLibrary

class ExampleDoubleSliderController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.view.addSubview(doubleSlider)

        doubleSlider.loadCurrentValue(20, 80)
    }

    // MARK: - Lazy Method
    lazy var doubleSlider: QSDoubleSlider = {
        let _slider = QSDoubleSlider(frame: CGRect(x: 16, y: 100, width: 300, height: 50))
        _slider.setupLimitRange(totalMin: -20, totalMax: 60, limitMin: 10, limitMax: 50)
        _slider.backgroundColor = .yellow
        _slider.unit = "C"
        _slider.delegate = self
        return _slider
    }()
}

extension ExampleDoubleSliderController: QSDoubleSliderDelegate {
    func didChangedLeftValue(_ sliderView: QSDoubleSlider, _ value: Double) {
        print(self, #function, "left :", value)
    }

    func didChangedRightValue(_ sliderView: QSDoubleSlider, _ value: Double) {
        print(self, #function, "right :", value)
    }
}
