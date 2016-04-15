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
    var leftTitle: String!
    var leftStat: String!
    var rightTitle: String!
    var rightStat: String!
    
}

extension StockStatsVC: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StockStatsCustomCell
        cell.labelLeftTitle.text = leftTitle
        cell.labelLeftStat.text = leftStat
        cell.labelRightTitle.text = rightTitle
        cell.labelRightStat.text = rightStat
        
        
        return cell
    }
    
}
