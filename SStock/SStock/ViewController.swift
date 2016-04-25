//
//  ViewController.swift
//  SStock
//
//  Created by Francisco Arrieta on 3/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class ViewController: UIViewController {
    
    var realmTableData: Results<RealmStock>!
    var realmUserData: Results<RealmUser>!
    var stockInfoIndex = 1
    
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
        for i in 0..<self.realmTableData.count{
            MarkitDataAPI.getQuote(realmTableData[i].symbol){
                (data) in dispatch_async(dispatch_get_main_queue()){
                    let realm = try! Realm()
                    try! realm.write(){
                        self.realmTableData[i].date = data.date
                        self.realmTableData[i].open = data.open
                        self.realmTableData[i].close = data.close
                        self.realmTableData[i].high = data.high
                        self.realmTableData[i].low = data.low
                        self.realmTableData[i].change = data.change
                        self.realmTableData[i].changePercent = data.changePercent
                    }
                }
            }
        }
        
//        Using this to temporally change one value to test update
//        let realm = try! Realm()
//        try! realm.write(){
//            realmTableData[3].close = 1.98
//        }
        
        
        refreshControl.endRefreshing()
        tableView.reloadData()
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
        MarkitDataAPI.getQuote(item.selectedStock.symbol){
            (data) in dispatch_async(dispatch_get_main_queue()){
                if self.isStockInPortfolio(data.symbol) == false{
                    let realm = try! Realm()
                    
                    try! realm.write(){
                        realm.add(data)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StockStatsVC"{
            if let selectedRow = tableView.indexPathForSelectedRow?.row{
                
                var stats = [String]()
                let vc = segue.destinationViewController as! StockStatsVC

                stats.append("Open")
                stats.append(String(self.realmTableData[selectedRow].open))
                stats.append("Close")
                stats.append(String(self.realmTableData[selectedRow].close))
                vc.stats.append(stats)
                
                // Clear stats to indicate a new row
                stats = []
                stats.append("High")
                stats.append(String(self.realmTableData[selectedRow].high))
                stats.append("Low")
                stats.append(String(self.realmTableData[selectedRow].low))
                vc.stats.append(stats)
                
                vc.header = String(self.realmTableData[selectedRow].symbol)
                
                stats = []
                stats.append("Change")
                stats.append(String(self.realmTableData[selectedRow].change))
                stats.append("%Change")
                stats.append(String(self.realmTableData[selectedRow].changePercent))
                vc.stats.append(stats)
            }
        }
    }
    
    func isStockInPortfolio(symbol: String) -> Bool{
        for i in 0..<realmTableData.count{
            if symbol == realmTableData[i].symbol{
                return true
            }
        }
        return false
    }
    @IBAction func buttonStockPriceClicked(sender: UIButton) {
        
        print(sender.titleLabel?.text)
        print(sender.tag)
//        sender.setTitle(String(self.realmTableData[sender.tag].changePercent), forState: UIControlState.Normal)
        var buttonTitle: String!
        switch self.stockInfoIndex {
        case 0:
            buttonTitle = "$" + String(self.realmTableData[sender.tag].close)
            sender.setTitle(buttonTitle, forState: UIControlState.Normal)
            stockInfoIndex = 1
        case 1:
            
            buttonTitle = "$" + String(self.realmTableData[sender.tag].change)
            sender.setTitle(buttonTitle, forState: UIControlState.Normal)
            stockInfoIndex = 2
        case 2:
            buttonTitle = String(self.realmTableData[sender.tag].changePercent) + "%"
            sender.setTitle(buttonTitle, forState: UIControlState.Normal)
            stockInfoIndex = 0
        default:
            buttonTitle = "$" + String(self.realmTableData[sender.tag].close)
            sender.setTitle(buttonTitle, forState: UIControlState.Normal)
            stockInfoIndex = 1
        }
    }
    
    func isStockPricePositive(index: Int) -> Bool{
        if self.realmTableData[index].changePercent > 0{
            return true
        }
        return false
    }
    
    func getGreenColor() -> UIColor{
        // Green is used when it is a positive price
        return UIColor(red: 1.0/255.0, green: 216.0/255.0, blue: 106.0/255.0, alpha: 1.0)
    }
    
    func getRedColor() -> UIColor{
        // Red is used when it is negative price
        return UIColor(red: 217.0/255.0, green: 83.0/255.0, blue: 79.0/255.0, alpha: 0.7)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PortfolioCustomTableViewCell
        
        cell.labelStockSymbol.text = self.realmTableData[indexPath.row].symbol
        cell.buttonStockPrice.setTitle(String(self.realmTableData[indexPath.row].close), forState: UIControlState.Normal)
        cell.buttonStockPrice.tag = indexPath.row
        if self.isStockPricePositive(indexPath.row){
            cell.buttonStockPrice.backgroundColor = self.getGreenColor()
        } else {
            cell.buttonStockPrice.backgroundColor = self.getRedColor()
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected a cell")
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
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
            
            let alert = UIAlertController(title: "Search User", message: "Enter a text", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = "" // Default text
            })

            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                print("cancelAction() called")
            }
            let sendAction: UIAlertAction = UIAlertAction(title: "Send", style: .Default, handler: { action -> Void in
                let textField = alert.textFields![0] as UITextField
                print("You enter: \(textField.text!)")
                if !self.sendStock(textField.text!, stock: self.realmTableData[indexPath.row].symbol){
                    alert.message = "You need to setup a user name"
                    
                    // create the alert
                    let alert = UIAlertController(title: "Error bud", message: "You need to setup a user name first.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
            alert.addAction(cancelAction)
            alert.addAction(sendAction)
            
            // http://stackoverflow.com/questions/33241052/xcode-iphone-6-plus-and-6s-plus-shows-warning-when-display-uialertviewcontroller
            alert.view.setNeedsLayout()
            self.presentViewController(alert, animated: true, completion: nil)
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [delete, share]
    }
    
    func sendStock(recipient: String, stock: String) -> Bool{
        if recipient.isEmpty{
            return false
        }
        
        let realm = try! Realm()
        realmUserData = realm.objects(RealmUser)
        if realmUserData.count > 0{
            let name = realmUserData[0].userName
            let rootRef = Firebase(url: "https://sstock.firebaseio.com/")
            let data = ["sender": name, "recipient": recipient, "stock": stock]
            let ref = rootRef.childByAutoId()
            ref.setValue(data)
        } else {
            print("You have to set up a user name")
            return false
        }
        
        
        return true
    }
    
}















