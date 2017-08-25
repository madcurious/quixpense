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
    @IBOutlet weak var categoryFieldView: CategoryFieldView!
    @IBOutlet weak var tagFieldView: TagFieldView!
    
    lazy var deleteView = ExpenseFormViewDeleteView(frame: .zero)
    
    var showsDeleteView = false {
        didSet {
            if showsDeleteView {
                // Don't add the delete button if it's been added before.
                guard deleteView.superview == nil
                    else {
                        return
                }
                contentStackView.addArrangedSubview(deleteView)
            } else {
                guard deleteView.superview == nil,
                    contentStackView.arrangedSubviews.contains(deleteView) else {
                        return
                }
                contentStackView.removeArrangedSubview(deleteView)
                deleteView.removeFromSuperview()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clearAllBackgroundColors()
        applyTheme()
        
        scrollView.alwaysBounceVertical = true
        
        amountFieldContainer.addSubviewsAndFill(amountFieldView)
        dateFieldContainer.addSubviewsAndFill(dateFieldView)
        
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
