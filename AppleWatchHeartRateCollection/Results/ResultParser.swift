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

struct ResultParser{
    
    static func getHKData(startDate: Date, endDate: Date){
        let healthStore = HKHealthStore()
        let hrType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]
        let hrQuery = HKSampleQuery(sampleType: hrType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: sortDescriptors){
            (query:HKSampleQuery, results:[HKSample]?, error: Error?) -> Void in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                guard let results = results as? [HKQuantitySample] else {
                    print("Data conversion error")
                    return
                }
                if results.count == 0 {
                    print("Empty Results")
                    return
                }
                TaskResults.hrDataStartDate = results[0].startDate
                TaskResults.hrPlotPoints = [ORKValueRange]()
                for (index, entry) in results.enumerated(){
                    if(index > 0){
                        if(entry.startDate.timeIntervalSince(results[index-1].startDate) > 5){
                            TaskResults.hrPlotPoints.append(ORKValueRange())
                        }
                    }
                    TaskResults.hrPlotPoints.append(ORKValueRange(value: entry.quantity.doubleValue(for: HKUnit(from: "count/min"))))
                }
            }
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
