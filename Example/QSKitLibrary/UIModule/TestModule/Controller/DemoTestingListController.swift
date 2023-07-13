//
//  DemoTestingListController.swift
//  QSKitLibrary_Example
//
//  Created by Soul on 2023/7/13.
//  Copyright © 2023 Quasi Team. All rights reserved.
//

import Foundation
import QSKitLibrary

class DemoTestingListController: QSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        autoPush()
    }

    override func addSubSnaps() {
        super.addSubSnaps()

        self.view.addSubview(button)
    }

    override func layoutSnaps() {
        super.layoutSnaps()

        self.button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }


    // MARK: - Test Method
    @objc private func autoPush() {
        pushToViewPager()
    }

    private func pushToViewPager() {
        let testVc = ExampleViewPagerController()
        self.navigationController?.pushViewController(testVc, animated: true)
    }

    // MARK: - Lazy Method
    private lazy var button: UIButton = {
        let _button = QSButton(design: .outstand32Bold, title: "测试页面")
        _button.setSolidBoardStyle()
        _button.addTarget(self, action: #selector(autoPush), for: .touchUpInside)
        return _button
    }()

}
