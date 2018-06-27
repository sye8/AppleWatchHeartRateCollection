//
//  ConsentTask.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

public var ConsentTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Consent Visualization
    let consentDocument = ConsentDocument()
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    //Sign and Review Consent
    let signature = consentDocument.signatures!.first!
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
    reviewConsentStep.text = "Review the consent form."
    reviewConsentStep.reasonForConsent = "Consent to join the research study."
    steps+=[reviewConsentStep]
    
    //Complete Consent
    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
    completionStep.title = "Welcome aboard."
    completionStep.text = "Thank you for joining this study."
    steps+=[completionStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
