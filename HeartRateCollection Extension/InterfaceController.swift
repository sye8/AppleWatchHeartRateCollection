//
//  InterfaceController.swift
//  HeartRateCollection Extension
//
//  Created by 叶思帆 on 02/07/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updatePayload), userInfo: nil, repeats: true)
    }
    
    override func didAppear() {
        super.didAppear()
        let sharedDefaults = UserDefaults(suiteName:"group.heartratecollection")
        sharedDefaults?.set("When prompted, please click the button below", forKey: "payload")
        sharedDefaults?.synchronize()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @objc func updatePayload(){
        let sharedDefaults = UserDefaults(suiteName: "group.heartratecollection")
        let payload = sharedDefaults?.object(forKey: "payload") as! String
        label.setText(payload)
    }

}
