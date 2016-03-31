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
//    static let api = "https://www.quandl.com/api/v3/datasets.json?database_code=WIKI&query="
//    static let returnCount = "&per_page=10&page=1"
    
    
    static let dataApi = "https://www.quandl.com/api/v3/datasets/WIKI/AAPL/data.json?start_date=2016-03-29&api_key=L9rgCQ9xtMJ2vExshXgw"
    
    
    //  https://www.quandl.com/api/v3/datasets/WIKI/FB.json?api_key=L9rgCQ9xtMJ2vExshXgw Check this for validation
    // https://www.quandl.com/api/v3/datasets/WIKI/AAPL/metadata.json?api_key=L9rgCQ9xtMJ2vExshXgw with question mark
    // https://www.quandl.com/api/v3/datasets.json?database_code=WIKI&query=apple&per_page=5&page=1&api_key=L9rgCQ9xtMJ2vExshXgw Use this THIS ONE IS PERFECT!!!!
    
    
    var example = "https://www.quandl.com/api/v3/datasets/WIKI/Ge.json?order=asc&exclude_column_names=true&start_date=2016-03-23&end_date=2016-03-24&column_index=4&collapse=weekly&transformation=rdiff?api_key=L9rgCQ9xtMJ2vExshXgw"
    
    static func search(text: String, completion: (stock: [Stock]) -> Void){
        
        let api = "https://www.quandl.com/api/v3/datasets.json?database_code=WIKI&query="
        let returnCount = "&per_page=10&page=1"
        
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
            var data = [Stock]()
            for stocks in datasets{
                let name = stocks["name"] as! String
                let dataset_code = stocks["dataset_code"] as! String
                let stock = Stock()
                stock.name = name
                stock.dataset_code = dataset_code
                data.append(stock)
            }
            completion(stock: data)
        }
        task.resume()
    }
    
    static func getCurrentDate() -> String{
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }
    
    static func getStockData(text: String, completion: (stock: Stock) -> Void){
        print("Received: " + text)
        // https://www.quandl.com/api/v3/datasets/WIKI/AAPL/data.json?start_date=2016-03-29&api_key=L9rgCQ9xtMJ2vExshXgw Use this for getting data
        
        
        let api = "https://www.quandl.com/api/v3/datasets/WIKI/"
        let currentDate = getCurrentDate()
        
        print(api + text + "/data.json?start_date=" + currentDate + apiKey)
        
        guard let escapedQuery = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
            let url = NSURL(string: api + escapedQuery + "/data.json?start_date=" + currentDate + apiKey)
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
            } catch {
                return
            }
//            print(json["dataset_data"]!)
//
            guard let dataset_data = json["dataset_data"] as? [String: AnyObject]
//            let data = dataset_data["data"] as? [AnyObject]
                else{
                    return
            }
            
            print(dataset_data["column_names"]!.count)
//            print(dataset_data["data"]![0].count)
//            let stock = Stock()
            
            // To get more information about a stock look at the dataset_data
//            let date = data[0] as! String
//            print(data[0])
//            let open = data[1] as! Double
//            let high = data[2] as! Double
//            let low = data[3] as! Double
//            let close = data[4] as! Double
////            stock.date = date
//            stock.open = open
//            stock.high = high
//            stock.low = low
//            stock.close = close
//            completion(stock: stock)
        }
        task.resume()
    }
}
