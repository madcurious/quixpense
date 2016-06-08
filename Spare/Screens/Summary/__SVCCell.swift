//
//  __SVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 08/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCCell: UICollectionViewCell {
    
    var total = NSDecimalNumber(integer: 0)
    var percent = 0
    
    weak var category: Category? {
        didSet {
            if let category = self.category {
                self.contentView.backgroundColor = category.color
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}