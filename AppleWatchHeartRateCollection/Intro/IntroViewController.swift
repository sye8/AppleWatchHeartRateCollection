//
//  ViewController.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toConsent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toConsent(){
        performSegue(withIdentifier: "toConsent", sender: self)
    }

}

