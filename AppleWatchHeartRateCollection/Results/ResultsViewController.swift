//
//  ResultViewController.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 05/07/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import UIKit

import ResearchKit

struct TaskResults{
    static var surveyResult = ORKTaskResult()
    static var hrStartDate = Date.distantPast
    static var hrEndDate = Date.distantFuture
    static var hrPlotpoints = [ORKValueRange]()
}

class ResultsViewController: UITableViewController{
    
    @IBOutlet var hrLineGraph: ORKLineGraphChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        print("Results View Will Appear")
        print("Start Date: \(TaskResults.hrStartDate)")
        print("End Date: \(TaskResults.hrEndDate)")
        if(TaskResults.hrStartDate != Date.distantPast && TaskResults.hrEndDate != Date.distantFuture){
            ResultParser.getHKData(startDate: TaskResults.hrStartDate, endDate: TaskResults.hrEndDate)
        }
        print(TaskResults.hrPlotpoints)
        hrLineGraph.dataSource = HeartRateDataSource(plotpoints: TaskResults.hrPlotpoints)
        // Set the table view to automatically calculate the height of cells.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        hrLineGraph.animate(withDuration: 0.5)
    }

}
