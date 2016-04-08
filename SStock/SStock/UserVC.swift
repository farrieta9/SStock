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
    var tableData = [(String, String)]()
    
    override func viewDidLoad() {
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
        
        rootRef.observeEventType(.ChildAdded, withBlock: {
            (snapchot) in
            
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
        return realmUserData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row].0
        cell.detailTextLabel?.text = tableData[indexPath.row].1
        
        return cell
    }
}
















