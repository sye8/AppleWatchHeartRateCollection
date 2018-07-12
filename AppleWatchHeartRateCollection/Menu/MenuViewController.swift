//
//  MenuViewController.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 28/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import UIKit

import ResearchKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func withdrawButtonTapped(sender: AnyObject){
        ORKPasscodeViewController.removePasscodeFromKeychain()
        performSegue(withIdentifier: "returnToConsent", sender: nil)
    }
    
    @IBAction func consentDocButtonHandler(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: consentPDFViewerTask(), taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func consentPDFViewerTask() -> ORKOrderedTask{
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        docURL = docURL?.appendingPathComponent("consent.pdf")
        let PDFViewerStep = ORKPDFViewerStep.init(identifier: "ConsentPDFViewer", pdfURL: docURL)
        return ORKOrderedTask(identifier: String("ConsentPDF"), steps: [PDFViewerStep])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MenuViewController: ORKTaskViewControllerDelegate{
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
