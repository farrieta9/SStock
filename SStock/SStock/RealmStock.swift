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
    dynamic var name = ""
    dynamic var dataset_code = "" //General Electric dataset_code is GE
    dynamic var date: String = ""
    dynamic var open: Double = 0.0
    dynamic var high: Double = 0.0
    dynamic var low: Double = 0.0
    dynamic var close: Double = 0.0
    
}