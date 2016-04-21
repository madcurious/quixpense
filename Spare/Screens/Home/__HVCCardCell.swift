//
//  __HVCCardCell.swift
//  Spare
//
//  Created by Matt Quiros on 21/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCCardCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
