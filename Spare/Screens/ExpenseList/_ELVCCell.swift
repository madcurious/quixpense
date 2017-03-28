//
//  _ELVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 21/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _ELVCCell: UITableViewCell, Themeable {
    
    var expense: Expense? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            self.amountLabel.text = AmountFormatter.displayText(for: self.expense?.amount)
            self.detailLabel.text = self.expense?.category?.name ?? nil
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.amountLabel.font = Font.regular(17)
        self.amountLabel.textAlignment = .left
        
        self.detailLabel.font = Font.regular(14)
        self.detailLabel.textAlignment = .right
        self.detailLabel.numberOfLines = 1
        self.detailLabel.lineBreakMode = .byTruncatingTail
        
        self.disclosureIndicatorImageView.image = UIImage.templateNamed("cellAccessoryDisclosureIndicator")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.amountLabel.textColor = Global.theme.color(for: .cellMainText)
        self.detailLabel.textColor = Global.theme.color(for: .cellSecondaryText)
        self.disclosureIndicatorImageView.tintColor = Global.theme.color(for: .cellAccessoryDisclosureIndicator)
    }
    
}
