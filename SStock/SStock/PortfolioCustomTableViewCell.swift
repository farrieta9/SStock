//
//  PortfolioCustomTableViewCell.swift
//  SStock
//
//  Created by Francisco Arrieta on 4/25/16.
//  Copyright © 2016 CS3200. All rights reserved.
//

import UIKit

class PortfolioCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonStockPrice: UIButton!
    @IBOutlet weak var labelStockSymbol: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        buttonStockPrice.layer.cornerRadius = 10
        buttonStockPrice.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        // Configure the view for the selected state
    }

}
