//
//  FilterPopupView.swift
//  Spare
//
//  Created by Matt Quiros on 30/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class FilterPopupView: UIView, Themeable {
    
    @IBOutlet weak var periodizationLabel: UILabel!
    @IBOutlet weak var periodizationControl: UISegmentedControl!
    
    @IBOutlet weak var groupingLabel: UILabel!
    @IBOutlet weak var groupingControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.periodizationLabel.font = Global.theme.font(for: .optionLabel)
        self.groupingLabel.font = Global.theme.font(for: .optionLabel)
        
        self.periodizationControl.setTitleTextAttributes([
            NSFontAttributeName : Global.theme.font(for: .regularText)
            ], for: .normal)
        self.groupingControl.setTitleTextAttributes([
            NSFontAttributeName : Global.theme.font(for: .regularText)
            ], for: .normal)
        
        self.periodizationLabel.textColor = Global.theme.color(for: .fieldName)
        self.groupingLabel.textColor = Global.theme.color(for: .fieldName)
        
        self.periodizationControl.tintColor = Global.theme.color(for: .controlTint)
        self.groupingControl.tintColor = Global.theme.color(for: .controlTint)
    }
    
}
