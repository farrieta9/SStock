//
//  StockManager.swift
//  SStock
//
//  Created by Francisco Arrieta on 3/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import Foundation

class StockManager
{
    static let apiKey = "&api_key=L9rgCQ9xtMJ2vExshXgw"
    //    static let api = "https://www.quandl.com/api/v3/datasets/WIKI/"
    static let returnType = ".json"
    static let api = "https://www.quandl.com/api/v3/datasets.json?database_code=WIKI&query="
    static let returnCount = "&per_page=10&page=1"
    
    //  https://www.quandl.com/api/v3/datasets/WIKI/FB.json?api_key=L9rgCQ9xtMJ2vExshXgw Check this for validation
    // https://www.quandl.com/api/v3/datasets/WIKI/AAPL/metadata.json?api_key=L9rgCQ9xtMJ2vExshXgw with question mark
    // https://www.quandl.com/api/v3/datasets.json?database_code=WIKI&query=apple&per_page=5&page=1&api_key=L9rgCQ9xtMJ2vExshXgw Use this THIS ONE IS PERFECT!!!!
    
    
    var example = "https://www.quandl.com/api/v3/datasets/WIKI/Ge.json?order=asc&exclude_column_names=true&start_date=2016-03-23&end_date=2016-03-24&column_index=4&collapse=weekly&transformation=rdiff?api_key=L9rgCQ9xtMJ2vExshXgw"
    
    static func search(text: String, completion: (stock: [Stock]) -> Void){
        print(api + text + returnCount + apiKey)
        guard let escapedQuery = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
            let url = NSURL(string: api + escapedQuery + returnCount + apiKey)
            else{
                return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){
            (data, response, error) in
            if error != nil{
                return
            }
            var json = [String: AnyObject]()
            do{
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
            } catch{
                return
            }
            
            guard let datasets = json["datasets"] as? [[String: AnyObject]]
                else{
                    return
            }
            // print(datasets[0]["name"]!)
            var data = [Stock]()
            for stocks in datasets{
                let name = stocks["name"] as! String
                let stock = Stock()
                stock.name = name
                data.append(stock)
            }
            completion(stock: data)
        }
        task.resume()
        
    }
}
