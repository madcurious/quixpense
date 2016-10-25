//
//  __HPVCSummaryCell.swift
//  Spare
//
//  Created by Matt Quiros on 25/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HPVCSummaryCell: UICollectionViewCell {
    
    var summary: Summary?
    
    class func applyAttributesToNameLabel(_ label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Heavy, 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
    class func applyAttributesTotalLabel(_ label: UILabel) {
        label.textColor = Color.UniversalTextColor
        label.font = Font.make(.Book, 16)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
    }
    
    class func height(for summary: Summary, atCellWidth cellWidth: CGFloat) -> CGFloat {
        fatalError()
    }
    
}
