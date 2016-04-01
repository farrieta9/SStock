//
//  ViewController.swift
//  SStock
//
//  Created by Francisco Arrieta on 3/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var realmTableData: Results<RealmStock>!
    
    // https://www.youtube.com/watch?v=_SHVgdONv8g
    let refreshControl: UIRefreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        realmTableData = realm.objects(RealmStock)
        
        refreshControl.addTarget(self, action: #selector(ViewController.refreshStocks), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refreshStocks(){
        print("refreshStocks() called")
        for i in 1...100000{
            print(i)
        }
        refreshControl.endRefreshing()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromSearchVC(sender: UIStoryboardSegue) {
        // http://stackoverflow.com/questions/12509422/how-to-perform-unwind-segue-programmatically
        let item = sender.sourceViewController as! SearchVC
        
        StockManager.getStockData(item.selectedStock.dataset_code){
            (data) in dispatch_async(dispatch_get_main_queue()){
                let realm = try! Realm()
                
                try! realm.write(){
                    realm.add(data)
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.realmTableData[indexPath.row].dataset_code
        cell.detailTextLabel?.text = String(self.realmTableData[indexPath.row].close)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // This is left blank intentionally to enable cell editing
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // http://stackoverflow.com/questions/32004557/swipe-able-table-view-cell-in-ios9-or-swift-guide-at-least
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            let item = self.realmTableData[indexPath.row]
            let realm = try! Realm()
            try! realm.write{
                realm.delete(item)
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
        
        delete.backgroundColor = UIColor.lightGrayColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [delete, share]
    }
    
}
