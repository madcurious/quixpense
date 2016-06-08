//
//  __HVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 29/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCCell: UICollectionViewCell {
    
    let summaryVC = SummaryVC(summary: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubviewAndFill(self.summaryVC.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
