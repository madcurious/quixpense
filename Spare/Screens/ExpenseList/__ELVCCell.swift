//
//  __ELVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __ELVCCell: UICollectionViewCell {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorLabel: UILabel!
    
    weak var expense: Expense? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            self.itemDescriptionLabel.text = self.expense?.itemDescription
            self.detailLabel.text = {[unowned self] in
                guard let amount = self.expense?.amount,
                    let paymentMethod = PaymentMethod(self.expense?.paymentMethod?.integerValue)
                    else {
                        return nil
                }
                return "\(glb_displayTextForTotal(amount)) " +
                    (paymentMethod == .Cash ? "in" : "via") +
                    " \(paymentMethod.text.lowercaseString)"
            }()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.labelContainer)
//        self.backgroundColor = UIColor.yellowColor()
        
        self.itemDescriptionLabel.font = Font.ExpenseListCellItemDescriptionLabel
        self.detailLabel.font = Font.ExpenseListCellDetailLabel
        
        self.disclosureIndicatorLabel.text = Icon.DisclosureIndicator.rawValue
        self.disclosureIndicatorLabel.font = Font.icon(22)
    }
    
}