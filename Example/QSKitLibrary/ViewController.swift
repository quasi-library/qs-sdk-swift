//
//  ViewController.swift
//  QSKitLibrary
//
//  Created by soulstayreal@gmail.com on 03/08/2022.
//  Copyright (c) 2022 Quasi Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushToButtonDemo(_ sender: Any) {
        let vc = QSButtonDemoController()
        self.navigationController?.show(vc, sender: nil)
    }
    
}

