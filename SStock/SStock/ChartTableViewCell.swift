//
//  ChartTableViewCell.swift
//  SStock
//
//  Created by Francisco Arrieta on 5/14/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell {

	@IBOutlet weak var lineChartView: LineChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		lineChartView.xAxis.labelPosition = .Bottom
		
		// Disable y axis label from appearing on the right side of the chart
		let yaxis = lineChartView.getAxis(ChartYAxis.AxisDependency.Right)
		yaxis.drawLabelsEnabled = false
		
		
		lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
		lineChartView.descriptionText = ""
		
		lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
		
		let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
		let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
		
		setChart(months, values: unitsSold)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setChart(dataPoints: [String], values: [Double]) {
		
		var dataEntries: [ChartDataEntry] = []
		
		for i in 0..<dataPoints.count {
			let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
			dataEntries.append(dataEntry)
		}
		
		let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
		let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
		lineChartView.data = lineChartData
		
	}

}
