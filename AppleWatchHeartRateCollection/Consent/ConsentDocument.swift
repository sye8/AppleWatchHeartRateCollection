//
//  ConsentDocument.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

class ConsentDocument: ORKConsentDocument {
    
    let sectionsText = [
        "Section 1: Welcome. The study is about...",
        "Section 2: Data Gathering. The study will gather your heart rate data from your Apple Watch...",
        "Section 3: Privacy. We value your privacy...",
        "Section 4: Data Use. The study will use your heart rate to...",
        "Section 5: Time Commitment. The study will only use your...",
        "Section 6: Study Survey. The study requires you to complete a survey to...",
        "Section 7: Study Tasks. The study requires you to complete...",
        "Section 8: Withdrawing. To withdraw from the study..."
    ]
    
    override init() {
        super.init()
        
        title = NSLocalizedString("Research Health Study Consent Form", comment: "")
        
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
        
        for sectionType in sectionTypes {
            let section = ORKConsentSection(type: sectionType)
            
            let localizedText = NSLocalizedString(sectionsText[sectionTypes.index(of: sectionType)!], comment: "")
            let localizedSummary = localizedText.components(separatedBy: ".")[0] + "."
            
            section.summary = localizedSummary
            section.content = localizedText

        }
        
        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        addSignature(signature)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ORKConsentSectionType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .overview:
            return "Overview"
            
        case .dataGathering:
            return "DataGathering"
            
        case .privacy:
            return "Privacy"
            
        case .dataUse:
            return "DataUse"
            
        case .timeCommitment:
            return "TimeCommitment"
            
        case .studySurvey:
            return "StudySurvey"
            
        case .studyTasks:
            return "StudyTasks"
            
        case .withdrawing:
            return "Withdrawing"
            
        case .custom:
            return "Custom"
            
        case .onlyInDocument:
            return "OnlyInDocument"
        }
    }
}
