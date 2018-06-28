//
//  VideoClip.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 28/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import Foundation

enum VideoClip: String{
    case avengerBattleRoyale = "battleRoyale"
    case nichijouCoffee = "nichijouCoffee"
    
    static func random() -> VideoClip {
        switch arc4random_uniform(2) {
            case 0:
                return .avengerBattleRoyale
            case 1:
                return .nichijouCoffee
            default:
                return .nichijouCoffee
        }
    }
    
    func fileURL() -> NSURL {
        return NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(self.rawValue, ofType: "mp4")!)
    }
    
}
