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
//        self.selectedDateLabel.backgroundColor = UIColor(hex: 0xcccccc)
        self.selectedDateLabel.textAlignment = .center
        self.selectedDateLabel.numberOfLines = 1
        self.selectedDateLabel.font = Font.make(.Heavy, 26)
        
        self.monthLabel.textColor = Color.CustomPickerTextColor
        self.monthLabel.textAlignment = .center
        self.monthLabel.font = Font.make(.Medium, 16)
        
        let arrowButtons = [self.previousButton, self.nextButton]
        for button in arrowButtons {
            button?.titleLabel?.font = Font.icon(20)
            button?.contentHorizontalAlignment = .center
            button?.tintColor = UIColor.black
        }
        self.previousButton.setTitle(Icon.Back.rawValue, for: UIControlState())
        self.nextButton.setTitle(Icon.Next.rawValue, for: UIControlState())
        
        let texts = ["S", "M", "T", "W", "T", "F", "S"]
        for i in 0 ..< self.headerLabels.count {
            let label = self.headerLabels[i]
            label.textAlignment = .center
            label.text = texts[i]
            label.font = Font.make(.Medium, 14)
            label.textColor = Color.CustomPickerHeaderTextColor
        }
    }
    
}
