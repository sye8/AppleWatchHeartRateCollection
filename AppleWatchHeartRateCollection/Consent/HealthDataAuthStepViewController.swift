//
//  HealthDataAuthStepViewController.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit
import HealthKit

class HealthDataStepViewController: ORKInstructionStepViewController {
    
    var healthDataStep: HealthDataStep? {
        return step as? HealthDataStep
    }
    
    override func goForward() {
        healthDataStep?.getHealthAuthorization(){succeeded, _ in
            guard succeeded || (TARGET_OS_SIMULATOR != 0) else { return }
            OperationQueue.main.addOperation {
                super.goForward()
            }
        }
    }
    
}

