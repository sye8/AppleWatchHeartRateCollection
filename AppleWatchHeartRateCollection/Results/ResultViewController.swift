//
//  ResultViewController.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 05/07/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import UIKit

import ResearchKit

class ResultViewController: UITableViewController{
    
    var result: ORKTaskResult
    
    init(result: ORKTaskResult){
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let source = String(describing: result.identifier)
//        print("Result from \(source)")
        switch source{
            case "SurveyTask":
                //Get results from ResearchKit
                ResultParser.findSurveyResults(result: self.result)
            case "HeartRateTask":
                //Get results from HealthKit
                ResultParser.findHeartRateResults(result: self.result)
            default:
                print("Unhandled results from \(source)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
