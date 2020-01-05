//
//  ChartView.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Charts
import Foundation
import UIKit

class ChartView: LineChartView {
    func setupChart(with totals: [Double], showLines: Bool = false) {
		setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
		backgroundColor = .clear
		gridBackgroundColor = .lightGray

        noDataText = ""
        areLinesVisible(showLines)
        
		let yAxis = leftAxis
//		yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
//		yAxis.setLabelCount(6, force: false)
//		yAxis.labelTextColor = .gray
//		yAxis.labelPosition = .insideChart
		yAxis.gridLineDashLengths = [2, 8]

		if totals.isEmpty { return }
		setDataCount(with: totals)
	}
    
    private func areLinesVisible(_ state: Bool) {
        setScaleEnabled(true)
        pinchZoomEnabled = false
        legend.enabled = false
        xAxis.enabled = false
        rightAxis.enabled = false
        dragEnabled = state
        leftAxis.enabled = state
    }
    
    func gradientColor() -> CGGradient {
        let gray = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        var gradientColors = [gray.cgColor, UIColor.white.cgColor] as CFArray
        if #available(iOS 13.0, *) {
            gradientColors = [UIColor.systemGray5.cgColor, UIColor.systemBackground.cgColor] as CFArray // Colors of the gradient
        }
        let colorLocations: [CGFloat] = [0.7, 0.0] // Positioning of the gradient
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        return gradient!
    }

	private func setDataCount(with totals: [Double]) {
		let count = totals.count
		let yVals1 = (0 ..< count).map { (i) -> ChartDataEntry in
			ChartDataEntry(x: Double(i), y: totals[i])
		}
		let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
		set1.mode = .cubicBezier
		set1.drawCirclesEnabled = false
		set1.drawFilledEnabled = true
		set1.highlightEnabled = true
		set1.drawHorizontalHighlightIndicatorEnabled = false

        let gradient = gradientColor()
		set1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        set1.fillAlpha = 0.8
		set1.lineWidth = 1
        set1.colors = [.darkGray]

		let data = LineChartData(dataSet: set1)
        data.setValueFont(UIFont.systemFont(ofSize: 15))
        data.setValueTextColor(.white)
		data.setDrawValues(false)

		self.data = data
	}
}
