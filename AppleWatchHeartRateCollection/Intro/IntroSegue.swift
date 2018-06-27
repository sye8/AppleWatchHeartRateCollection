//
//  IntroSegue.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 27/06/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import UIKit

class IntroSegue: UIStoryboardSegue {
    
    override func perform() {
        let controllerToReplace = source.childViewControllers.first
        let destinationControllerView = destination.view
        
        destinationControllerView?.translatesAutoresizingMaskIntoConstraints = true
        destinationControllerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destinationControllerView?.frame = source.view.bounds
        
        controllerToReplace?.willMove(toParentViewController: nil)
        source.addChildViewController(destination)
        
        source.view.addSubview(destinationControllerView!)
        controllerToReplace?.view.removeFromSuperview()
        
        destination.didMove(toParentViewController: source)
        controllerToReplace?.removeFromParentViewController()
    }
}
