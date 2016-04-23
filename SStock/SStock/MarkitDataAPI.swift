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
}

