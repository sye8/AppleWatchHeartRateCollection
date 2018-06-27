//
//  HealthDataAuth.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit
import HealthKit

class HealthDataStep: ORKInstructionStep {
    
    let healthKitStore = HKHealthStore()
    
    let healthDataItemsToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
    let healthDataItemsToWrite: Set<HKSampleType> = []
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = NSLocalizedString("Health Data", comment: "")
        text = NSLocalizedString("On the next screen, you will be prompted to grant access to read your heart rate data for this study.", comment: "")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHealthAuthorization(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        HKHealthStore().requestAuthorization(toShare: healthDataItemsToWrite, read: healthDataItemsToRead){ (success, error) -> Void in
            completion(success, error as NSError?)
        }
    }
}
