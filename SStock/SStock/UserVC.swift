//
//  UserVC.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/3/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit

class UserVC: UIViewController{
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSave(sender: UIBarButtonItem) {
        print("onSave() called")
    }
}
