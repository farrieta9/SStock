//
//  StockStatsVC.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/15/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import RealmSwift

class StockStatsVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
//    var realmStock : RealmStock {
//        didSet {    
//            leftTitle = realmStock.date
//        }
//    }
    var leftTitle: String!
    var leftStat: String!
    var rightTitle: String!
    var rightStat: String!
    var header: String!
    
    var stats = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(stats.count)
        print(stats[0])
    }
}

extension StockStatsVC: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StockStatsCustomCell
        
        print(indexPath.section)
        if indexPath.section == 0{
            cell.labelLeftTitle.text = stats[indexPath.row][0]
            cell.labelLeftStat.text = stats[indexPath.row][1]
            cell.labelRightTitle.text = stats[indexPath.row][2]
            cell.labelRightStat.text = stats[indexPath.row][3]
        }
        
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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













