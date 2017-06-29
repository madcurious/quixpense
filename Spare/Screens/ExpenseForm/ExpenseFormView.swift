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
        
        self.clearBackgrounds(from: self.scrollView)
        self.applyTheme()
        
        self.scrollView.alwaysBounceVertical = true
        
        self.amountFieldContainer.addSubviewsAndFill(self.amountFieldView)
        self.dateFieldContainer.addSubviewsAndFill(self.dateFieldView)
        self.categoryFieldContainer.addSubviewsAndFill(self.categoryFieldView)
        self.tagFieldContainer.addSubviewsAndFill(self.tagFieldView)
        
        self.requiredLabel.text = "REQUIRED"
        self.optionalLabel.text = "OPTIONAL"
    }
    
    func applyTheme() {
        self.backgroundColor = Global.theme.color(for: .mainBackground)
        
        let sectionLabels = [self.requiredLabel, self.optionalLabel];
        for sectionLabel in sectionLabels {
            sectionLabel?.font = Global.theme.font(for: .groupedTableViewSectionHeader)
            sectionLabel?.textColor = Global.theme.color(for: .groupedTableViewSectionHeader)
        }
        
        for separatorView in self.separatorViews {
            separatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        }
    }
    
    /// Recursive function that clears the background of `superview` and its subviews.
    private func clearBackgrounds(from superview: UIView) {
        if let stackView = superview as? UIStackView {
            for subview in stackView.arrangedSubviews {
                self.clearBackgrounds(from: subview)
            }
        } else {
            superview.backgroundColor = .clear
            for subview in superview.subviews {
                self.clearBackgrounds(from: subview)
            }
        }
    }
    
}
