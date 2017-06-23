//
//  FilterPopupView.swift
//  Spare
//
//  Created by Matt Quiros on 30/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class FilterPopupView: UIView, Themeable {
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var periodizationLabel: UILabel!
    @IBOutlet weak var periodizationControl: UISegmentedControl!
    
    @IBOutlet weak var groupingLabel: UILabel!
    @IBOutlet weak var groupingControl: UISegmentedControl!
    
    @IBOutlet weak var contentLeading: NSLayoutConstraint!
    @IBOutlet weak var contentTop: NSLayoutConstraint!
    @IBOutlet weak var contentTrailing: NSLayoutConstraint!
    @IBOutlet weak var contentBottom: NSLayoutConstraint!
    
    let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.periodizationLabel.text = "PERIODIZATION"
        let periodizationTexts = [Filter.Periodization.day.text(),
                                  Filter.Periodization.week.text(),
                                  Filter.Periodization.month.text()]
        for i in 0 ..< periodizationTexts.count {
            self.periodizationControl.setTitle(periodizationTexts[i], forSegmentAt: i)
        }
        
        self.groupingLabel.text = "GROUPING"
        let groupingTexts = [Filter.Grouping.category.text().capitalized,
                             Filter.Grouping.tag.text().capitalized]
        for i in 0 ..< groupingTexts.count {
            self.groupingControl.setTitle(groupingTexts[i], forSegmentAt: i)
        }
        
        self.contentTop.constant = self.contentInsets.top
        self.contentTrailing.constant = self.contentInsets.right
        self.contentBottom.constant = self.contentInsets.bottom
        self.contentLeading.constant = self.contentInsets.left
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.periodizationLabel.font = Global.theme.font(for: .optionLabel)
        self.groupingLabel.font = Global.theme.font(for: .optionLabel)
        
        self.periodizationControl.setTitleTextAttributes([
            NSAttributedStringKey.font : Global.theme.font(for: .regularText)
            ], for: .normal)
        self.groupingControl.setTitleTextAttributes([
            NSAttributedStringKey.font : Global.theme.font(for: .regularText)
            ], for: .normal)
        
        self.periodizationLabel.textColor = Global.theme.color(for: .groupedTabledViewSectionHeader)
        self.groupingLabel.textColor = Global.theme.color(for: .groupedTabledViewSectionHeader)
        
        self.periodizationControl.tintColor = Global.theme.color(for: .controlTint)
        self.groupingControl.tintColor = Global.theme.color(for: .controlTint)
    }
    
}
