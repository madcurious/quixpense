//
//  __DPVCView.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __DPVCView: CustomPickerView {
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var arrowContainer: UIView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var pageVCContainer: UIView!
    
    @IBOutlet var headerLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.arrowContainer,
            self.headerContainer,
            self.pageVCContainer
        )
        
        self.selectedDateLabel.textColor = Color.CustomPickerTextColor
        self.selectedDateLabel.textAlignment = .Center
        self.selectedDateLabel.numberOfLines = 1
        self.selectedDateLabel.font = Font.make(.Heavy, 30)
        
        self.monthLabel.textColor = Color.CustomPickerTextColor
        self.monthLabel.textAlignment = .Center
        self.monthLabel.font = Font.make(.Medium, 18)
        
        let arrowButtons = [self.previousButton, self.nextButton]
        for button in arrowButtons {
            button.titleLabel?.font = Font.icon(20)
            button.contentHorizontalAlignment = .Center
            button.tintColor = UIColor.blackColor()
        }
        self.previousButton.setTitle(Icon.Back.rawValue, forState: .Normal)
        self.nextButton.setTitle(Icon.Next.rawValue, forState: .Normal)
        
        let texts = ["S", "M", "T", "W", "T", "F", "S"]
        for i in 0 ..< self.headerLabels.count {
            let label = self.headerLabels[i]
            label.textAlignment = .Center
            label.text = texts[i]
            label.font = Font.make(.Medium, 14)
            label.textColor = Color.CustomPickerHeaderTextColor
        }
    }
    
}
