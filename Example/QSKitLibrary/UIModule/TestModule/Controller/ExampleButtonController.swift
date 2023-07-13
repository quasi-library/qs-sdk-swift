//
//  QSButtonDemoController.swift
//  QSKitLibrary_Example
//
//  Created by GengJian on 2022/3/8.
//  Copyright © 2022 Quasi Team. All rights reserved.
//

import UIKit
import QSKitLibrary

class ExampleButtonController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.systemYellow
        self.title = "测试VSButton"
        
        showButton1()
        showButton2()
        
    }
    

    private func showButton1(){
        let button1 = QSButton.init(type: UIButton.ButtonType.system)
        button1.frame = CGRect.init(x: 50, y: 150, width: 100, height: 50)
        button1.setTitle("实心按钮", for: .normal)
        button1.setSolidBoardStyle()
        self.view.addSubview(button1)
    }
    
    private func showButton2(){
        let button2 = QSButton.init(type: UIButton.ButtonType.system)
        button2.frame = CGRect.init(x: 50, y: 250, width: 100, height: 50)
        button2.setTitle("空心按钮", for: .normal)
        button2.setHollowBoardStyle()
        self.view.addSubview(button2)
    }
}
