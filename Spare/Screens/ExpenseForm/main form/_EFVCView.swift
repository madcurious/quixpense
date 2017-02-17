//
//  _EFVCView.swift
//  Spare
//
//  Created by Matt Quiros on 15/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    let amountBox = _EFVCAmountBox.instantiateFromNib()
    let dateBox = _EFVCButtonBox.instantiateFromNib()
    let categoryBox = _EFVCButtonBox.instantiateFromNib()
    let subcategoriesBox = _EFVCButtonBox.instantiateFromNib()
    let paymentMethodsBox = _EFVCButtonBox.instantiateFromNib()
    let itemNameBox = _EFVCButtonBox.instantiateFromNib()
    let notesBox = _EFVCNotesBox.instantiateFromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.alwaysBounceVertical = true
        self.stackView.spacing = 6
        
        let buttonBoxData = [
            ("DATE", "dateIcon", "Required"),
            ("CATEGORY", "categoryIcon", "Food, Transportation, etc."),
            ("SUBCATEGORIES", "subcategoriesIcon", "Personal, Work, etc."),
            ("PAYMENT METHODS", "paymentMethodsIcon", "Cash, Credit, Rewards Card, etc."),
            ("ITEM NAME", "itemNameIcon", "e.g. Breakfast at Tiffany's")
        ]
        
        let fieldBoxes = [self.amountBox, self.dateBox, self.categoryBox, self.subcategoriesBox, self.paymentMethodsBox, self.itemNameBox, self.notesBox]
        for i in 0 ..< fieldBoxes.count {
            switch i {
            case 1 ... 5:
                let data = buttonBoxData[i - 1]
                fieldBoxes[i].fieldLabel.text = data.0
                fieldBoxes[i].iconImageView.image = UIImage.templateNamed(data.1)
                (fieldBoxes[i] as! _EFVCButtonBox).fieldButton.placeholder = data.2
                fallthrough
                
            default:
                self.stackView.addArrangedSubview(fieldBoxes[i])
            }
        }
    }
    
}
