//
//  ChartView.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartView: LineChartView {
    
    func setupChart(with totals: [Double]) {
        self.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
        self.backgroundColor = .white
        self.gridBackgroundColor = .lightGray
        
        self.dragEnabled = false
        self.setScaleEnabled(true)
        self.pinchZoomEnabled = false
               
        self.xAxis.enabled = false
        self.leftAxis.enabled = false
               
        let yAxis = self.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .gray
        yAxis.labelPosition = .insideChart
        yAxis.gridLineDashLengths = [2, 8]
        
        self.rightAxis.enabled = false
        self.legend.enabled = false
        self.setDataCount(with: totals)
    }
    
    func setDataCount(with totals: [Double]) {
        let count = totals.count
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: totals[i])
        }

        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.drawFilledEnabled = true
        set1.highlightEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        
        let gray = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        let gradientColors = [gray.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations: [CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        set1.fillAlpha = 1
        set1.lineWidth = 0
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        
        self.data = data
    }
}
