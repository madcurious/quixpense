//
//  __ELVCBEmptyView.swift
//  Spare
//
//  Created by Matt Quiros on 29/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __ELVCBEmptyView: UIView {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.labelContainer)
        
        self.iconLabel.font = Font.icon(160)
        self.iconLabel.textColor = Color.UniversalSecondaryTextColor
        self.iconLabel.text = Icon.Empty.rawValue
        self.iconLabel.textAlignment = .Center
        
        self.promptLabel.font = Font.ExpenseListEmptyViewPromptLabel
        self.promptLabel.textColor = Color.UniversalSecondaryTextColor
        self.promptLabel.numberOfLines = 0
        self.promptLabel.lineBreakMode = .ByWordWrapping
        self.promptLabel.text = "You have no expenses in this period."
        self.promptLabel.textAlignment = .Center
    }
    
}
