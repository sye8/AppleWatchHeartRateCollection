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
    
    static func getSurveyResults(result: ORKTaskResult){
        //Question Step
        if let questionStepResult = result.stepResult(forStepIdentifier: "QuestionStep"){
            let stepResults = questionStepResult.results
            let questionResult = stepResults![0] as! ORKTextQuestionResult
            let answer = questionResult.textAnswer
            print("Short Question Answer: \(answer)")
        }
        //Text Choice Step
        if let textChoiceStepResult = result.stepResult(forStepIdentifier: "TextChoiceStep"){
            let stepResults = textChoiceStepResult.results
            let questionResult = stepResults![0] as! ORKChoiceQuestionResult
            let answer = questionResult.choiceAnswers
            print("Text Choice Answer: \(answer)")
        }
        //Image Choice Step
        if let imageChoiceStepResult = result.stepResult(forStepIdentifier: "ImageChoiceStep"){
            let stepResults = imageChoiceStepResult.results
            let questionResult = stepResults![0] as! ORKChoiceQuestionResult
            let answer = questionResult.choiceAnswers
            print("Image Choice Answer: \(answer)")
        }
    }
    
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
                resultViaHTTP(results: results)
                TaskResults.hrDataStartDate = results[0].startDate
                TaskResults.hrPlotPoints = [ORKValueRange]()
                for (index, entry) in results.enumerated(){
                    if(index > 0){
                        if(entry.startDate.timeIntervalSince(results[index-1].startDate) > 6){
                            TaskResults.hrPlotPoints.append(ORKValueRange())
                        }
                    }
                    TaskResults.hrPlotPoints.append(ORKValueRange(value: entry.quantity.doubleValue(for: HKUnit(from: "count/min"))))
                }
            }
        }
        healthStore.execute(hrQuery)
    }
    
    static func resultToDict(sample: HKQuantitySample) -> [String : String]{
        var dict: [String:String] = [:]
        dict["hr"] = "\(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))"
        dict["startDate"] = "\(sample.startDate)"
        dict["endDate"] = "\(sample.endDate)"
        let source = sample.sourceRevision.source
        dict["sourceName"] = "\(source.name)"
        dict["sourceBundleID"] = "\(source.bundleIdentifier)"
        return dict
    }
    
    static func resultViaHTTP(results: [HKQuantitySample]){
        var toSend: [[String: String]] = []
        for result in results{
            toSend.append(resultToDict(sample: result))
        }
        resultJSONviaHTTP(results: toSend)
    }
    
    static func resultJSONviaHTTP(results: [[String: String]]){
        var request = URLRequest(url: URL(string: "http://169.254.187.95:8080/AppleWatchDataReceiver/Receiver")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if JSONSerialization.isValidJSONObject(results){
            do{
                print("Try sending via HTTP")
                let data = try JSONSerialization.data(withJSONObject: results, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
                let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    if error != nil{
                        print(error)
                        return
                    }
                }
                task.resume()
            }catch{
                print("Error while sending JSON via HTTP")
            }
        }else{
            print("Invalid JSON Object")
        }
    }
}
