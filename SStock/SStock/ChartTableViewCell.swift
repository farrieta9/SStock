//
//  ChartTableViewCell.swift
//  SStock
//
//  Created by Francisco Arrieta on 5/14/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import Charts


class ChartTableViewCell: UITableViewCell, ChartViewDelegate {

	@IBOutlet weak var lineChartView: LineChartView!
	
//	let marker = BalloonMarker(color: UIColor.blueColor(), font: UIFont (name: "HelveticaNeue-UltraLight", size: 30), insets: <#T##UIEdgeInsets#>)
	
	var chartBackgroundColor: UIColor!

    override func awakeFromNib() {
        super.awakeFromNib()
		lineChartView.drawMarkers = true
		lineChartView.delegate = self
		lineChartView.xAxis.labelPosition = .Bottom
		
		// Disable y axis label from appearing on the right side of the chart
		let yaxis = lineChartView.getAxis(ChartYAxis.AxisDependency.Right)
		yaxis.drawLabelsEnabled = false
		
		setChartBackgroundColor(189, green: 195, blue: 199, transparent: 1)
		lineChartView.descriptionText = ""

		// Turn off the values that appear on top of the graph
		lineChartView.maxVisibleValueCount = 1
    }
	
	func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
		print(entry.value)
		print(chartView.getMarkerPosition(entry: entry, highlight: highlight))
	}
	
	func getChartBackgroundColor() -> UIColor {
		return chartBackgroundColor
	}
	
	func setChartBackgroundColor(red: CGFloat, green: CGFloat, blue: CGFloat, transparent: CGFloat){
		chartBackgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: transparent)
		self.lineChartView.backgroundColor = chartBackgroundColor
	}
	
	func setChart(dataPoints: [String], values: [Double]) {
		
		var dataEntries: [ChartDataEntry] = []
		
		for i in 0..<dataPoints.count {
			let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
			dataEntries.append(dataEntry)
		}
		
		let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
		
		// Makes the blue circle/dots disappear
		lineChartDataSet.drawCirclesEnabled = false
		
		// Fills the area under the graph
		lineChartDataSet.drawFilledEnabled = true
		
		let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
		
		lineChartView.data = lineChartData
		
		lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
	}
}
