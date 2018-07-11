//
//  HeartRateTask.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 28/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

public var HeartRateTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "Instruction")
    instructionStep.title = "TV + Heart Rate"
    instructionStep.text = "<Description>"
    steps += [instructionStep]
    
    let watchStep = ORKActiveStep(identifier: "Watch")
    watchStep.title = "TV + Heart Rate"
    watchStep.text = "Please open the corresponding app on your watch and press \"Start Recording\"."
    steps += [watchStep]
    
    let baselineCountdown = ORKActiveStep(identifier: "BaselineCountdown")
    baselineCountdown.title = "TV + Heart Rate"
    baselineCountdown.text = "Baseline measurement will start in 10 seconds"
    baselineCountdown.stepDuration = 10
    baselineCountdown.shouldShowDefaultTimer = true
    baselineCountdown.shouldStartTimerAutomatically = true
    baselineCountdown.shouldContinueOnFinish = true
    steps += [baselineCountdown]
    
    let baselineStep = ORKActiveStep(identifier: "Baseline")
    baselineStep.title = "TV + Heart Rate"
    baselineStep.text = "Taking a baseline measurement for 30 seconds"
    baselineStep.stepDuration = 30
    baselineStep.shouldShowDefaultTimer = true
    baselineStep.shouldStartTimerAutomatically = true
    baselineStep.shouldContinueOnFinish = true
    steps += [baselineStep]
    
    let heartrateCountdown = ORKActiveStep(identifier: "HRCountdown")
    heartrateCountdown.title = "TV + Heart Rate"
    heartrateCountdown.text = "Please be ready\nActivity will start in 10 seconds"
    heartrateCountdown.stepDuration = 10
    heartrateCountdown.shouldShowDefaultTimer = true
    heartrateCountdown.shouldStartTimerAutomatically = true
    heartrateCountdown.shouldContinueOnFinish = true
    steps += [heartrateCountdown]
    
    let heartrateStep = ORKActiveStep(identifier: "HeartRate")
    heartrateStep.stepDuration = 60
    heartrateStep.shouldShowDefaultTimer = true
    heartrateStep.shouldStartTimerAutomatically = true
    heartrateStep.shouldContinueOnFinish = true
    heartrateStep.title = "TV + Heart Rate"
    heartrateStep.text = "Please <do sth> for 1 minute."
    steps += [heartrateStep]
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you!"
    summaryStep.text = "<text>\nNow you can press \"Stop Recording\" on your watch\nYou can check the results in the results tab\nIf it shows no data, tap \"Refresh\" to update the results"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "HeartRateTask", steps: steps)
}

