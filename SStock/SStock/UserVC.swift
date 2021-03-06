//
//  UserVC.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/3/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class UserVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var realmUserData: Results<RealmUser>!
    var rootRef = Firebase(url: "https://sstock.firebaseio.com/")
    var tableData = [(String, String, String)]()
    
    override func viewDidLoad() {
        self.tableData.append(("", "", ""))
        super.viewDidLoad()
        let realm = try! Realm()

        realmUserData = realm.objects(RealmUser)
        if realmUserData.count > 0{
            let name = realmUserData[0].userName
            print(realmUserData.count)
            self.title = name
            textField.text = name
        } else {
            print("Nothing in RealmUser")
        }
        
        rootRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            print(snapshot)
            if let newChat = snapshot.value as? [String: String]{
                guard var recipient = newChat["recipient"],
                var sender = newChat["sender"],
                let stock = newChat["stock"]
                    else{
                        return
                }
                if sender == self.title {
                    sender = "You recommended: " + stock + " to " + recipient
                    recipient = ""
                    self.tableData.insert((recipient, sender, stock), atIndex: 0)
                    
                } else  if recipient == self.title {
                    sender = sender + " recommends: " + stock
                    recipient = ""
                    self.tableData.insert((sender, recipient, stock), atIndex: 0)
                }
                
            }
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        })
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSave(sender: UIBarButtonItem) {
        print("onSave() called")
        print(textField.text!)
        
        if textField.text!.isEmpty{
            textField.text = "Enter a user name"
            return
        }
        if realmUserData.count > 0{
            let realm = try! Realm()
            try! realm.write() {
                realmUserData[0].userName = textField.text!
            }
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            let realm = try! Realm()
            let user = RealmUser()
            user.userName = textField.text!
            try! realm.write() {
//                realmUserData.userName = textField.text!
                realm.add(user)
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}


extension UserVC: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row].0
        cell.textLabel?.textColor = UIColor.blueColor()
        cell.detailTextLabel?.text = tableData[indexPath.row].1
        cell.detailTextLabel?.textColor = UIColor.greenColor()
        
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
















