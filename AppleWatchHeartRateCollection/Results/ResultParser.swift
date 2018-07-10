//
//  ResultParser.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 29/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import Foundation
import HealthKit

import ResearchKit

struct TaskResults{
    static var surveyResult = ORKTaskResult()
    static var hrStartDate = Date.distantPast
    static var hrEndDate = Date.distantFuture
}

struct ResultParser{
    
    static func findSurveyResults(result: ORKTaskResult){
        print("Survey Results: ")
        print(result)
    }
 
    static func findHeartRateResults(result: ORKTaskResult){
        print("Heart Rate Results")
        if let results = result.results, results.count > 2, let hrResult = results[2] as? ORKStepResult{
            print("Start and end time stamp")
            let start = hrResult.startDate
            let end = hrResult.endDate
            print("Start: \(start); End: \(end)")
            getHRFromHealthKit(startDate: start, endDate: end)
        }
    }
    
    static func getHRFromHealthKit(startDate: Date, endDate: Date){
        let healthStore = HKHealthStore()
        let hrType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let hrQuery = HKSampleQuery(sampleType: hrType,
                                predicate: predicate,
                                limit: Int(HKObjectQueryNoLimit),
                                sortDescriptors: sortDescriptors){
            (query:HKSampleQuery, results:[HKSample]?, error: Error?) -> Void in
                guard error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                printHR(results: results)
        }
        healthStore.execute(hrQuery)
    }
    
    static func printHR(results: [HKSample]?){
        guard let results = results as? [HKQuantitySample] else { return }
        print("Number of data points: \(results.count)")
        for result in results{
            print("HR: \(result.quantity.doubleValue(for: HKUnit(from: "count/min")))")
            print("Start Date: \(result.startDate)")
            print("End Date: \(result.endDate)")
            print("Source: \(result.sourceRevision)")
            print("\n")
        }
    }
    
}
