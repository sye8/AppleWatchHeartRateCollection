//
//  InterfaceController.swift
//  HeartRateCollection Extension
//
//  Created by 叶思帆 on 02/07/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import HealthKit
import WatchKit

class IntroInterfaceController: WKInterfaceController{

    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    var isRecording = false
    
    //For workout session
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var currentQuery: HKQuery?
    
    override func awake(withContext context: Any?){
        // Configure interface objects here.
        super.awake(withContext: context)
    }
    
    override func willActivate(){
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //Check HealthStore
        guard HKHealthStore.isHealthDataAvailable() == true else {
            print("Health Data Not Avaliable")
            return
        }
        
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
            startWorkout() //Start workout session/healthkit streaming
        }else{
            let exitTitle = NSMutableAttributedString(string: "Start Recording")
            exitTitle.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.green], range: NSMakeRange(0, exitTitle.length))
            button.setAttributedTitle(exitTitle)
            isRecording = false
            healthStore.end(session!)
            presentController(withName: "Done", context: nil)
        }
    }
}

extension IntroInterfaceController: HKWorkoutSessionDelegate{
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
            case .running:
                if let query = heartRateQuery(date){
                    self.currentQuery = query
                    healthStore.execute(query)
                }
            case .ended:
                healthStore.stop(self.currentQuery!)
                session = nil
            default:
                print("Unexpected state: \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //Do Nothing
    }
    
    func startWorkout(){
        // If a workout has already been started, do nothing.
        if (session != nil) {
            return
        }
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create workout session")
        }
        
        healthStore.start(self.session!)
        print("Start Workout Session")
    }
    
    func heartRateQuery(_ startDate: Date) -> HKQuery? {
        let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType!, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //Do nothing
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            guard let samples = samples as? [HKQuantitySample] else {return}
            DispatchQueue.main.async {
                guard let sample = samples.first else { return }
                let value = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                self.label.setText(String(UInt16(value)))
            }
        }
        
        return heartRateQuery
    }
    
}
