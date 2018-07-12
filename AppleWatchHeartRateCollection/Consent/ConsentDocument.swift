//
//  ConsentDocument.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

public var ConsentDocument: ORKConsentDocument {
    
    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Research Study Consent Form"
    
    let sectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .timeCommitment,
        .studySurvey,
        .studyTasks,
        .withdrawing
    ]
    
    let text = [
        "Section 1: Welcome. This study is about...",
        "Section 2: Data Gathering. This study will collect data from your Apple Watch...",
        "Section 3: Privacy. We value your privacy...",
        "Section 4: Data Use. The data collected will be used for...",
        "Section 5: Time Commitment. This study will take you roughly...",
        "Section 6: Study Survey. For this study, you will need to fill out a survey...",
        "Section 7: Study Tasks. You will be requested to do these tasks...",
        "Section 8: Withdrawing. To withdraw from the study..."
    ]
    
    consentDocument.sections = []
    
    for sectionType in sectionTypes {
        let section = ORKConsentSection(type: sectionType)
        
        let localizedText = NSLocalizedString(text[sectionTypes.index(of: sectionType)!], comment: "")
        let localizedSummary = localizedText.components(separatedBy: ".")[0] + "."
        
        section.summary = localizedSummary
        section.content = localizedText
        
        if consentDocument.sections == nil {
            consentDocument.sections = [section]
        } else {
            consentDocument.sections!.append(section)
        }
    }
    
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: "Participant", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
        
    return consentDocument
}
