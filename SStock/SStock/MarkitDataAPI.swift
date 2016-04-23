//
//  MarkitDataAPI.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/22/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import Foundation


class MarkitDataAPI{
    // For using http and not https
    //http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
    
    // Look up http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=DWTI
    // Quote http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=GE
    
    static func search(text: String, completion: (stock: [Stock]) -> Void){
        if text.isEmpty{
            return
        }
        
        let api = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input="
        
        guard let escapedQuery = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
        let url = NSURL(string: api + escapedQuery)
        else{
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){
            (data, response, error) in
            if error != nil{
                print("ERROR")
                return
            }
            var json = [AnyObject]()
            do{
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [AnyObject]
            } catch{
                return
            }
            
            var data = [Stock]()
            for index in json{
                let symbol = index["Symbol"] as! String
                let name = index["Name"] as! String
                let stock = Stock()
                stock.symbol = symbol
                stock.name = name
                data.append(stock)
            }
            completion(stock: data)
        }
        task.resume()
    }
    
    static func getQuote(symbol: String, completion: (stock: RealmStock) -> Void){
        print("getQuote() called")
        let api = "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol="
        
        guard let escapedQuery = symbol.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
            let url = NSURL(string: api + escapedQuery)
            else{
                return
        }
        
        print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){
            (data, response, error) in
            if error != nil{
                print("ERROR")
                return
            }
            var json = [String: AnyObject]()
            do{
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String:AnyObject]
            } catch{
                return
            }
//            print(json)
//            print(json["Name"])
//            print(json.count)
            let status = json["Status"] as! String
            if status != "SUCCESS"{
                return
            }
            
            var change = json["Change"] as! Double
            var changePercent = json["ChangePercent"] as! Double
            let high = json["High"] as! Double
            let lastPrice = json["LastPrice"] as! Double
            let low = json["Low"] as! Double
            let name = json["Name"] as! String
            let open = json["Open"] as! Double
            let symbol = json["Symbol"] as! String
            
            change = roundToPlaces(change, places: 2)
            changePercent = roundToPlaces(changePercent, places: 2)
            
            let stock = RealmStock()
            stock.change = change
            stock.changePercent = changePercent
            stock.close = lastPrice
            stock.low = low
            stock.high = high
            stock.name = name
            stock.open = open
            stock.symbol = symbol
            
            
            completion(stock: stock)
        }
        task.resume()
    }
    
    // http://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
    static func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
}

