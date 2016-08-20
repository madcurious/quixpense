//
//  __DPVCPageCell.swift
//  Spare
//
//  Created by Matt Quiros on 21/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __DPVCPageCell: UICollectionViewCell {
    
    let monthPageVC = MonthPageVC()
    
    var month: NSDate? {
        get {
            return self.monthPageVC.month
        }
        set {
            self.monthPageVC.month = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubviewAndFill(self.monthPageVC.view)
    }
    
}
