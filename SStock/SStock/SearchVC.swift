//
//  SearchVC.swift
//  SStock
//
//  Created by Francisco Arrieta on 3/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit

class SearchVC: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [Stock]()
    var selectedStock = Stock()
    
}

extension SearchVC: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        print("SearchVC --- You entered: " + searchBar.text!)
//        searchBar.resignFirstResponder() // Make the keyboard go down
//        StockManager.search(searchBar.text!){
//            (stocks) in dispatch_async(dispatch_get_main_queue()){
//                self.tableData = stocks
//                self.tableView.reloadData()
//            }
//        }
//        view.endEditing(true) // Make the keyboard go down
//    }
    
//    Search as you type
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        MarkitDataAPI.search(searchText){
            (stocks) in dispatch_async(dispatch_get_main_queue()){
                self.tableData = stocks
                self.tableView.reloadData()
            }
        }
//        searchBar.resignFirstResponder() // Make the keyboard go down
//        StockManager.search(searchBar.text!){
//            (stocks) in dispatch_async(dispatch_get_main_queue()){
//                self.tableData = stocks
//                self.tableView.reloadData()
//            }
//        }
//        view.endEditing(true) // Make the keyboard go down
    }
}

extension SearchVC: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].symbol
        cell.detailTextLabel?.text = tableData[indexPath.row].name
        
        return cell
    }
}

extension SearchVC: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedStock = self.tableData[indexPath.row]
        
        // Dismiss screen upon clicking on a row
        self.performSegueWithIdentifier("unwindFromSearchVC", sender: self)
        navigationController?.popViewControllerAnimated(true) // Is this call necessary?
    }
}








