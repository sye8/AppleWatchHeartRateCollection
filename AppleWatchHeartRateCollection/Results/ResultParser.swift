//
//  ResultParser.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 29/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import Foundation

import ResearchKit

struct ResultParser{
    
    static func findSurveyResults(result: ORKTaskResult){
        print("Survey Results: ")
        print(result)
    }
 
    static func findHeartRateResults(result: ORKTaskResult){
        print("Heart Rate Results")
        if let results = result.results, results.count > 2, let hrResult = results[2] as? ORKStepResult{
            print("Start and end time stamp")
            print(hrResult.startDate)
            print(hrResult.endDate)
        }
    }
    
}
