//
//  __ELVCBCell.swift
//  Spare
//
//  Created by Matt Quiros on 29/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __ELVCBCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    
    var data: (Expense, Periodization)? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let (expense, periodization) = self.data
                else {
                    return
            }
            
            if let amount = expense.amount {
                self.leftLabel.text = AmountFormatter.displayTextForAmount(amount)
            }
            
            var rightText = ""
            if let note = expense.note {
                rightText += note
            }
            if let paymentMethodNumber = expense.paymentMethod,
                let paymentMethod = PaymentMethod(paymentMethodNumber.intValue)
                , periodization == .day && rightText.isEmpty == true {
                rightText += paymentMethod.text
            }
            self.rightLabel.text = rightText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.contentView)
        
        self.leftLabel.numberOfLines = 1
        self.leftLabel.lineBreakMode = .byClipping
        self.leftLabel.textColor = Color.UniversalTextColor
        self.leftLabel.font = Font.ExpenseListCellText
        
        self.rightLabel.numberOfLines = 1
        self.rightLabel.lineBreakMode = .byTruncatingTail
        self.rightLabel.textColor = Color.UniversalSecondaryTextColor
        self.rightLabel.font = Font.ExpenseListCellText
        self.rightLabel.textAlignment = .right
        
        self.arrowLabel.attributedText = NSAttributedString(string: Icon.DisclosureIndicator.rawValue, font: Font.icon(20), textColor: Color.UniversalSecondaryTextColor)
    }
    
}
