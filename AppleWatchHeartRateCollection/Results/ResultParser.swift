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

class ResultParser: NSObject, URLSessionDelegate{
    
    static func getSurveyResults(result: ORKTaskResult){
        let rp = ResultParser()
        rp.surveyViaHTTP(result: result)
    }
    
    static func getHKData(startDate: Date, endDate: Date, isBaseline: Bool){
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
                let rp = ResultParser()
                rp.resultViaHTTP(results: results, isBaseline: isBaseline)
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
    
    func surveyViaHTTP(result: ORKTaskResult){
        var dict: [String: String] = [:]
        dict["id"] = TaskResults.id
        if let questionStepResult = result.stepResult(forStepIdentifier: "QuestionStep"){
            let questionResult = questionStepResult.results![0] as! ORKTextQuestionResult
            dict["shortQuestionAnswer"] = questionResult.textAnswer
        }else{
            dict["shortQuestionAnswer"] = "null"
        }
        if let textChoiceStepResult = result.stepResult(forStepIdentifier: "TextChoiceStep"){
            let questionResult = textChoiceStepResult.results![0] as! ORKChoiceQuestionResult
            if let ans = questionResult.choiceAnswers{
                dict["textChoiceAnswer"] = ans.description
            }else{
                dict["textChoiceAnswer"] = "null"
            }
        }else{
            dict["textChoiceAnswer"] = "null"
        }
        if let imageChoiceStepResult = result.stepResult(forStepIdentifier: "ImageChoiceStep"){
            let questionResult = imageChoiceStepResult.results![0] as! ORKChoiceQuestionResult
            if let ans = questionResult.choiceAnswers{
                dict["imageChoiceAnswer"] = ans.description
            }else{
                dict["imageChoiceAnswer"] = "null"
            }
        }else{
            dict["imageChoiceAnswer"] = "null"
        }
        
        var request = URLRequest(url: URL(string: "https://172.24.1.1:8443/AppleWatchDataReceiver/Survey")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if JSONSerialization.isValidJSONObject(dict){
            do{
                let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
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
    
    func resultToDict(sample: HKQuantitySample) -> [String : String]{
        var dict: [String:String] = [:]
        dict["hr"] = "\(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))"
        dict["startDate"] = "\(sample.startDate)"
        dict["endDate"] = "\(sample.endDate)"
        return dict
    }
    
    func resultViaHTTP(results: [HKQuantitySample], isBaseline: Bool){
        var toSend: [[String: String]] = []
        var id = TaskResults.id
        if isBaseline {
            id = id + "_Baseline"
        }
        if let descriptionResult = TaskResults.textFieldResult{
            let description = descriptionResult.results![0] as! ORKTextQuestionResult
            id = id + " " + description.textAnswer!
        }
        toSend.append(["id" : id])
        for result in results{
            toSend.append(resultToDict(sample: result))
        }
        resultJSONviaHTTP(results: toSend)
    }
    
    func resultJSONviaHTTP(results: [[String: String]]){
        
        var request = URLRequest(url: URL(string: "https://172.24.1.1:8443/AppleWatchDataReceiver/Receiver")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if JSONSerialization.isValidJSONObject(results){
            do{
                let data = try JSONSerialization.data(withJSONObject: results, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    if let error = error{
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
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.host == "172.24.1.1" {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
}
