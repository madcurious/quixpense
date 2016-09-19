//
//  __ELVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __ELVCCell: UITableViewCell {
    
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var disclosureImageView: UIImageView!
    
    weak var expense: Expense? {
        didSet {
            if let expense = self.expense {
                self.amountLabel.text = AmountFormatter.displayTextForAmount(expense.amount)
                
                var description = ""
                if let note = expense.note {
                    description += note + ", "
                }
                if let paymentMethod = PaymentMethod(expense.paymentMethod?.integerValue) {
                    description += paymentMethod.text
                }
                self.descriptionLabel.text = description
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self,
            self.contentView,
            self.wrapperView
            )
        
        self.amountLabel.font = Font.make(.Book, 18)
        self.amountLabel.numberOfLines = 1
        self.amountLabel.textColor = Color.UniversalTextColor
        
        self.descriptionLabel.font = Font.make(.Book, 18)
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.lineBreakMode = .ByWordWrapping
        self.descriptionLabel.textAlignment = .Right
        self.descriptionLabel.textColor = Color.UniversalSecondaryTextColor
        
        self.disclosureImageView.image = UIImage.templateNamed("disclosureIcon")
        self.disclosureImageView.tintColor = UIColor(hex: 0xD8D8D8)
    }
    
}