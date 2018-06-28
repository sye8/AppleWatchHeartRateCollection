//
//  HeartRateTask.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 28/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit
import HealthKit

public var HeartRateTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    
    
    return ORKOrderedTask(identifier: "HeartRateTask", steps: steps)
}

