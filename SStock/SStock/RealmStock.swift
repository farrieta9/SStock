//
//  RealmStock.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/1/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStock: Object{
    // See http://dev.markitondemand.com/MODApis/#doc_quote
    dynamic var change = 0.0
    dynamic var changePercent = 0.0
    dynamic var close: Double = 0.0 // can also be the lastprice
    dynamic var name = ""
    dynamic var date: String = "" // Deprecated
    dynamic var high: Double = 0.0
    dynamic var low: Double = 0.0
    dynamic var open: Double = 0.0
    dynamic var symbol = "" // General Electric symbol is GE
}