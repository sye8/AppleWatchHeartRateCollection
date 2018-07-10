//
//  HeartRateDataSource.swift
//  AppleWatchHeartRateCollection
//
//  Created by 叶思帆 on 10/07/2018.
//  Copyright © 2018 Sifan Ye. All rights reserved.
//

import ResearchKit

class HeartRateDataSource: NSObject, ORKValueRangeGraphChartViewDataSource{
    
    var plotpoints: [ORKValueRange]
    
    init(plotpoints: [ORKValueRange]){
        self.plotpoints = plotpoints
        super.init()
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        return plotpoints[pointIndex]
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return plotpoints.count
    }
    
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func maximumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 200
    }
    
    func minimumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 30
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        return "\(pointIndex + 1)"
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, drawsPointIndicatorsForPlotIndex plotIndex: Int) -> Bool {
        return true
    }
}
