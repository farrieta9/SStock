//
//  ViewController.swift
//  SStock
//
//  Created by Francisco Arrieta on 3/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var stocks = ["Google", "GE", "AMD"]
    
    var tableData = [Stock]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func unwind(sender: UIStoryboardSegue){
//        let sourceVC = sender.sourceViewController as! AddNewImageVC
//        
//        let realm = try! Realm()
//        let photo = Photo()
//        photo.title = sourceVC.textField_Title.text!
//        photo.location = sourceVC.label_Location.text!
//        photo.imageData = UIImageJPEGRepresentation(sourceVC.imageView_newImage.image!, 1.0)!
//        
//        try! realm.write(){
//            realm.add(photo)
//        }
//        collectionView.reloadData()
//    }
    
    @IBAction func unwindFromSearchVC(sender: UIStoryboardSegue) {
        // http://stackoverflow.com/questions/12509422/how-to-perform-unwind-segue-programmatically
        // Second solution worked from 
        print("Start")
        let item = sender.sourceViewController as! SearchVC
        print(item.selectedStock.dataset_code)
        tableData.append(item.selectedStock)
        print("END")
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stocks.count
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
//        cell.textLabel?.text = stocks[indexPath.row]
//        cell.textLabel?.text = self.tableData[indexPath.row]
        cell.textLabel?.text = self.tableData[indexPath.row].dataset_code
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // This is left blank intentionally to enable cell editting
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // http://stackoverflow.com/questions/32004557/swipe-able-table-view-cell-in-ios9-or-swift-guide-at-least
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
//            self.stocks.removeAtIndex(indexPath.row)
            self.tableData.removeAtIndex(indexPath.row)
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

