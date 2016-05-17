//
//  StockStatsVC.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/15/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import RealmSwift
import Charts


class StockStatsVC: UIViewController{
	
    @IBOutlet weak var tableView: UITableView!
    var leftTitle: String!
    var leftStat: String!
    var rightTitle: String!
    var rightStat: String!
    var header: String!
    
    var stats = [[String]]()
	var stockData = [[AnyObject]!]()
	var chartXAxis = [String]()
	var chartYAxis = [Double]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		StockManager.getStockDataForGraphing(header, daysAgo: 30){
			(data) in dispatch_async(dispatch_get_main_queue()){
				self.stockData = data
				self.parseStockData()
				self.tableView.reloadData()
			}
		}
	}
	
	func parseStockData(){
		var xAxis = [String]()
		var yAxis = [Double]()
		for data in self.stockData {
			xAxis.append(data[0] as! String)
			yAxis.append(Double(data[1] as! NSNumber))
		}
		chartXAxis = xAxis
		chartYAxis = yAxis
		tableView.reloadData()
	}
}


extension StockStatsVC: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("chartCell", forIndexPath: indexPath) as! ChartTableViewCell
			cell.backgroundColor = cell.getChartBackgroundColor()
			cell.setChart(self.chartXAxis, values: self.chartYAxis)
			
			return cell
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! StockStatsCustomCell
		cell.labelLeftTitle.text = stats[indexPath.row][0]
		cell.labelLeftStat.text = stats[indexPath.row][1]
		cell.labelRightTitle.text = stats[indexPath.row][2]
		cell.labelRightStat.text = stats[indexPath.row][3]
		return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 300
		}
		return 50
	}
}


extension StockStatsVC: UITableViewDelegate{
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return header
        }
        return ""
    }
}














