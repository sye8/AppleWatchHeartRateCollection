//
//  HeartRateTask.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 28/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import HealthKit

import ResearchKit

public var HeartRateTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "instruction")
    instructionStep.title = "TV + Heart Rate"
    instructionStep.text = "<Description>"
    steps += [instructionStep]
    
    let config = ORKHealthQuantityTypeRecorderConfiguration(identifier: "heartRateConfig", healthQuantityType: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, unit: HKUnit(from: "bpm"))
    let heartrateStep = ORKActiveStep(identifier: "heartrate")
    heartrateStep.stepDuration = 30
    heartrateStep.recorderConfigurations = [config]
    heartrateStep.shouldShowDefaultTimer = true
    heartrateStep.shouldStartTimerAutomatically = true
    heartrateStep.shouldContinueOnFinish = true
    heartrateStep.title = "Please <do sth> for 30 seconds"
    steps += [heartrateStep]
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you!"
    summaryStep.text = "<text>"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "HeartRateTask", steps: steps)
}

