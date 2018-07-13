//
//  SurveyTask.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 28/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Instruction
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Survey Instructions"
    instructionStep.text = "This survey will provide us..."
    steps += [instructionStep]
    
    //Short text Input Question
    let shortAnswerFormat = ORKTextAnswerFormat(maximumLength: 32)
    shortAnswerFormat.multipleLines = false
    let shortAnswerStepTitle = "Single Line, Short Answer, 32 chars"
    let shortAnswerStep = ORKQuestionStep(identifier: "QuestionStep", title: shortAnswerStepTitle, answer: shortAnswerFormat)
    steps += [shortAnswerStep]
    
    //Text Choice Question
    let textChoiceStepTitle = "Text Choice"
    let textChoices = [
        ORKTextChoice(text: "Choice 1", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Choice 2", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Choice 3", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
    ]
    let textChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let textChoiceStep = ORKQuestionStep(identifier: "TextChoiceStep", title: textChoiceStepTitle, answer: textChoiceAnswerFormat)
    steps += [textChoiceStep]
    
    //Image Choice Question
    let imageChoiceQuestionStepTitle = "Börk Børk Björk?"
    let imageChoiceTuples = [
        (UIImage(named: "Germany")!, "Germany"),
        (UIImage(named: "Russia")!, "Russia"),
        (UIImage(named: "France")!, "France"),
        (UIImage(named: "Sweden")!, "Sweden"),
    ]
    let imageChoices : [ORKImageChoice] = imageChoiceTuples.map {
        return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSCoding & NSCopying & NSObjectProtocol)
    }
    let imageChoiceAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
    let imageChoiceQuestionStep = ORKQuestionStep(identifier: "ImageChoiceStep", title: imageChoiceQuestionStepTitle, answer: imageChoiceAnswerFormat)
    steps += [imageChoiceQuestionStep]
    
    //Other Tasks
    //Date
    //Boolean
    //Continuous
    
    //Summary
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you."
    summaryStep.text = "We appreciate your time."
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
