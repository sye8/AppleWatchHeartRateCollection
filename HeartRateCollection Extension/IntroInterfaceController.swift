//
//  InterfaceController.swift
//  HeartRateCollection Extension
//
//  Created by 叶思帆 on 02/07/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import HealthKit
import WatchKit

class IntroInterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    var isRecording = false
    
    override func awake(withContext context: Any?){
        // Configure interface objects here.
        super.awake(withContext: context)
    }
    
    override func willActivate(){
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didAppear(){
        super.didAppear()
    }

    override func didDeactivate(){
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func buttonHandler(){
        if(!isRecording){
            let stopTitle = NSMutableAttributedString(string: "Stop Recording")
            stopTitle.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: NSMakeRange(0, stopTitle.length))
            button.setAttributedTitle(stopTitle)
            isRecording = true
        }else{
            let exitTitle = NSMutableAttributedString(string: "Start Recording")
            exitTitle.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.green], range: NSMakeRange(0, exitTitle.length))
            button.setAttributedTitle(exitTitle)
            isRecording = false
            presentController(withName: "Done", context: nil)
        }
    }
    
}
