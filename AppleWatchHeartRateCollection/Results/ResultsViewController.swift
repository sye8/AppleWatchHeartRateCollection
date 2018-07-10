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
        let hrLineGraphChartView = hrLineGraphChartCell.graphView as! ORKLineGraphChartView
        let hrDataSource = hrLineGraphChartView.dataSource as! HeartRateDataSource
        hrDataSource.updatePlotPoints(newPlotPoints: [
                ORKValueRange(value: 2),
                ORKValueRange(value: 4),
                ORKValueRange(value: 8),
                ORKValueRange(value: 16),
                ORKValueRange(value: 32),
                ORKValueRange(value: 64),
            ])
        hrLineGraphChartCell.graphView.reloadData()
        hrLineGraphChartCell.graphView.animate(withDuration: 0.5)
    }
    
}

class HRLineGraphChartCell: UITableViewCell{
    @IBOutlet weak var graphView: ORKGraphChartView!
}
