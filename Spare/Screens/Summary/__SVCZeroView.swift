//
//  __SVCZeroView.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCZeroView: UIView {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var verticalSpacing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.UniversalBackgroundColor
        UIView.clearBackgroundColors(
            self.labelContainer,
            self.totalLabel,
            self.dateLabel
        )
        
        self.totalLabel.font = Font.make(.Heavy, 100)
        self.totalLabel.numberOfLines = 1
        self.totalLabel.textAlignment = .center
        self.totalLabel.textColor = Color.UniversalSecondaryTextColor
        self.totalLabel.text = AmountFormatter.displayTextForAmount(NSDecimalNumber(value: 0 as Int))
        
        self.dateLabel.numberOfLines = 1
        self.dateLabel.font = Font.make(.Book, 40)
        self.dateLabel.adjustsFontSizeToFitWidth = true
        self.dateLabel.textColor = Color.UniversalSecondaryTextColor
        self.dateLabel.textAlignment = .center
        
        self.promptLabel.textColor = Color.UniversalSecondaryTextColor
        self.promptLabel.numberOfLines = 0
        self.promptLabel.lineBreakMode = .byWordWrapping
        self.promptLabel.textAlignment = .center
        self.promptLabel.font = Font.make(.Medium, 18)
        self.promptLabel.text = "To see a chart, you must go out and\nspend your money."
        
        self.verticalSpacing.constant = self.bounds.size.height * 0.2
    }
    
}
