//
//  __DPVCDayCell.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __DPVCDayCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
    }
    
}
