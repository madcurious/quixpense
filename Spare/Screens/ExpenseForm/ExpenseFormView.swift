//
//  ExpenseFormView.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseFormView: UIView, Themeable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet var separatorViews: [UIView]!
    
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var amountFieldContainer: UIView!
    let amountFieldView = AmountFieldView.instantiateFromNib()
    @IBOutlet weak var dateFieldContainer: UIView!
    let dateFieldView = DateFieldView.instantiateFromNib()
    
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var categoryFieldContainer: UIView!
    let categoryFieldView = CategoryFieldView.instantiateFromNib()
    @IBOutlet weak var tagFieldContainer: UIView!
    let tagFieldView = TagFieldView.instantiateFromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clearAllBackgroundColors()
        applyTheme()
        
        scrollView.alwaysBounceVertical = true
        
        amountFieldContainer.addSubviewsAndFill(amountFieldView)
        dateFieldContainer.addSubviewsAndFill(dateFieldView)
        categoryFieldContainer.addSubviewsAndFill(categoryFieldView)
        tagFieldContainer.addSubviewsAndFill(tagFieldView)
        
        requiredLabel.text = "REQUIRED"
        optionalLabel.text = "OPTIONAL"
    }
    
    func applyTheme() {
        backgroundColor = Global.theme.color(for: .mainBackground)
        
        let sectionLabels = [requiredLabel, optionalLabel];
        for sectionLabel in sectionLabels {
            sectionLabel?.font = Global.theme.font(for: .groupedTableViewSectionHeader)
            sectionLabel?.textColor = Global.theme.color(for: .groupedTableViewSectionHeader)
        }
        
        for separatorView in separatorViews {
            separatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        }
    }
    
}
