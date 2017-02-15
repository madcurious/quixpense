//
//  _EFVCFieldBox.swift
//  Spare
//
//  Created by Matt Quiros on 15/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCFieldBox: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var fieldLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.contentView)
        
        self.fieldLabel.font = Font.regular(10)
        self.fieldLabel.textColor = Global.theme.fieldLabelTextColor
        self.fieldLabel.numberOfLines = 1
        self.fieldLabel.lineBreakMode = .byTruncatingTail
        
        self.separatorView.backgroundColor = Global.theme.tableViewSeparatorColor
        self.separatorViewHeight.constant = 0.5
    }
    
}
