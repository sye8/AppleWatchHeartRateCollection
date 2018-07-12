//
//  ConsentViewController.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

class ConsentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ConsentViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        switch reason{
            case .completed:
                let signatureResult: ORKConsentSignatureResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.firstResult as! ORKConsentSignatureResult
                let consentDocument = ConsentDocument.copy() as! ORKConsentDocument
                signatureResult.apply(to: consentDocument)
                consentDocument.makePDF{ (data, error) -> Void in
                    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
                    docURL = docURL?.appendingPathComponent("consent.pdf")
                    try? data?.write(to: docURL!, options: .atomicWrite)
                }
                performSegue(withIdentifier: "unwindToTasks", sender: nil)
            case .discarded, .failed, .saved:
                dismiss(animated: true, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataStep {
            let healthStepViewController = HealthDataStepViewController(step: step)
            return healthStepViewController
        }
        return nil
    }
    
}
