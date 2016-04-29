//
//  __HVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 29/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCCell: UICollectionViewCell {
    
    let cardVC = CardVC()
    
    var data: [[String : AnyObject]]? {
        get {
            return self.cardVC.data
        }
        set {
            self.cardVC.data = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubviewAndFill(self.cardVC.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
