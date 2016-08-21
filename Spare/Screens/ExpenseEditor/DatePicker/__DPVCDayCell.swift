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
        
        UIView.clearBackgroundColors(self, self.contentView)
        
        self.dateLabel.layer.borderColor = UIColor.blackColor().CGColor
        self.dateLabel.layer.borderWidth = 1
        
        self.dateLabel.textAlignment = .Center
        self.dateLabel.textColor = Color.CustomPickerTextColor
        self.dateLabel.font = Font.make(.Medium, 20)
    }
    
}
