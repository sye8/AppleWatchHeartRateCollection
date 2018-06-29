//
//  ResultParser.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 29/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import Foundation

import ResearchKit

struct ResultParser{
    
    static func findHeartRate(result: ORKTaskResult) -> URL?{
        
        if let results = result.results,
            results.count > 1,
            let heartResult = results[1] as? ORKStepResult,
            let heartSubresults = heartResult.results,
            heartSubresults.count > 0,
            let fileResult = heartSubresults[0] as? ORKFileResult,
            let fileURL = fileResult.fileURL{
            
            return fileURL
        }
        
        return nil
    }
    
}
