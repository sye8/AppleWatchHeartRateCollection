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
    
    let instructionStep = ORKInstructionStep(identifier: "Instruction")
    instructionStep.title = "TV + Heart Rate"
    instructionStep.text = "<Description>\nPlease open the corresponding app on your watch and press \"Start Recording\"."
    steps += [instructionStep]
    
    let heartrateCountdown = ORKActiveStep(identifier: "Countdown")
    heartrateCountdown.title = "TV + Heart Rate"
    heartrateCountdown.text = "Activity will start in 5 seconds"
    heartrateCountdown.stepDuration = 5
    heartrateCountdown.shouldShowDefaultTimer = true
    heartrateCountdown.shouldStartTimerAutomatically = true
    heartrateCountdown.shouldContinueOnFinish = true
    steps += [heartrateCountdown]
    
    let config = ORKHealthQuantityTypeRecorderConfiguration(identifier: "heartRateConfig", healthQuantityType: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, unit: HKUnit(from: "count/min"))
    let heartrateStep = ORKActiveStep(identifier: "HeartRate")
    heartrateStep.stepDuration = 60
    heartrateStep.recorderConfigurations = [config]
    heartrateStep.shouldShowDefaultTimer = true
    heartrateStep.shouldStartTimerAutomatically = true
    heartrateStep.shouldContinueOnFinish = true
    heartrateStep.title = "TV + Heart Rate"
    heartrateStep.text = "Please <do sth> for 1 minute."
    steps += [heartrateStep]
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you!"
    summaryStep.text = "<text>\nNow you can press \"Stop Recording\" on your watch."
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "HeartRateTask", steps: steps)
}

