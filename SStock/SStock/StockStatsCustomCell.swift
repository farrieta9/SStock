//
//  StockStatsCustomCell.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/15/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit

class StockStatsCustomCell: UITableViewCell {

    @IBOutlet weak var labelLeftTitle: UILabel!
    @IBOutlet weak var labelLeftStat: UILabel!
    @IBOutlet weak var labelRightTitle: UILabel!
    @IBOutlet weak var labelRightStat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}