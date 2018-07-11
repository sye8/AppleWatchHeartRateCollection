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
    static var baselineStartDate = Date.distantPast
    static var baselineEndDate = Date.distantFuture
    static var baselineAvg: Double = 0.0
    static var hrStartDate = Date.distantPast
    static var hrEndDate = Date.distantFuture
    static var hrDataStartDate = Date.distantPast
    static var hrPlotPoints = [ORKValueRange]()
}

class ResultsViewController: UITableViewController{
    
    let hrLineGraphDataSource = HeartRateDataSource()
    let hrLineGraphChartID = "HRLineGraphChartCell"
    
    var hrLineGraphChartCell: HRLineGraphChartCell!
    
    var chartCells: [UITableViewCell]!
    
    override func viewDidLoad() {
        hrLineGraphChartCell = tableView.dequeueReusableCell(withIdentifier: hrLineGraphChartID) as! HRLineGraphChartCell
        let hrLineGraphChartView = hrLineGraphChartCell.graphView as! ORKLineGraphChartView
        hrLineGraphChartView.dataSource = hrLineGraphDataSource
        hrLineGraphChartView.tintColor = UIColor(red: 255/255, green: 41/255, blue: 135/255, alpha: 1)
        
        chartCells = [hrLineGraphChartCell]
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chartCells[(indexPath as NSIndexPath).row];
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.allowsSelection = false
        hrLineGraphChartCell.refresh()
    }
    
}

class HRLineGraphChartCell: UITableViewCell{
    @IBOutlet weak var graphView: ORKGraphChartView!
    @IBOutlet weak var taskStartDateLabel: UILabel!
    @IBOutlet weak var dataStartDateLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBAction func refreshButtonHandler(_ sender: Any) {
        self.refresh()
    }
    
    func refresh(){
        if(TaskResults.hrStartDate != Date.distantPast && TaskResults.hrEndDate != Date.distantFuture){
            ResultParser.getHKBaseline(startDate: TaskResults.baselineStartDate, endDate: TaskResults.baselineEndDate)
            ResultParser.getHKData(startDate: TaskResults.hrStartDate, endDate: TaskResults.hrEndDate)
            let hrLineGraphChartView = self.graphView as! ORKLineGraphChartView
            let hrDataSource = hrLineGraphChartView.dataSource as! HeartRateDataSource
            hrDataSource.updatePlotPoints(newPlotPoints: TaskResults.hrPlotPoints)
            if(TaskResults.hrDataStartDate != Date.distantPast){
                self.taskStartDateLabel.text = "\(TaskResults.hrStartDate)"
                self.dataStartDateLabel.text = "\(TaskResults.hrDataStartDate)"
                self.descriptionLabel.text = "Data will be cleared when app is closed"
                print("Baseline: \(TaskResults.baselineAvg)")
            }
            hrLineGraphChartView.reloadData()
        }else{
            self.taskStartDateLabel.text = "N/A"
            self.dataStartDateLabel.text = "N/A"
            self.descriptionLabel.text = "Tap \"Refresh\" to update chart"
        }
        self.refreshButton.layer.cornerRadius = 5
        self.refreshButton.clipsToBounds = true
        self.graphView.animate(withDuration: 0.5)
    }
}
