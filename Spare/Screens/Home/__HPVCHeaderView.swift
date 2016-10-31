//
//  __HPVCHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 31/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HPVCHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var data: (dateRange: DateRange, total: NSDecimalNumber)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (dateRange, total) = self.data
                else {
                return
            }
            
            self.dateLabel.text = DateFormatter.displayText(for: dateRange)
            self.totalLabel.text = AmountFormatter.displayTextForAmount(total)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.wrapperView)
//        self.wrapperView.backgroundColor = UIColor.red
        
        self.dateLabel.numberOfLines = 1
        self.dateLabel.lineBreakMode = .byTruncatingTail
        self.dateLabel.textColor = Color.UniversalTextColor
        self.dateLabel.font = Font.make(.Book, 17)
        
        self.totalLabel.numberOfLines = 1
        self.totalLabel.lineBreakMode = .byTruncatingTail
        self.totalLabel.textColor = Color.UniversalTextColor
        self.totalLabel.font = Font.make(.Heavy, 17)
    }
    
}
