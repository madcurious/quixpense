//
//  __ELVCHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __ELVCHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self,
            self.contentView
        )
        
        self.nameLabel.font = Font.make(.Heavy, 36)
        self.nameLabel.textColor = Color.UniversalTextColor
        self.nameLabel.numberOfLines = 0
        self.nameLabel.lineBreakMode = .ByWordWrapping
        self.nameLabel.textAlignment = .Center
        
        self.totalLabel.font = Font.make(.Heavy, 22)
        self.totalLabel.textColor = Color.UniversalTextColor
        self.totalLabel.numberOfLines = 1
        self.totalLabel.lineBreakMode = .ByClipping
        self.totalLabel.textAlignment = .Center
        
        self.detailLabel.font = Font.make(.Heavy, 22)
        self.detailLabel.textColor = Color.UniversalTextColor
        self.detailLabel.numberOfLines = 0
        self.detailLabel.lineBreakMode = .ByWordWrapping
        self.detailLabel.textAlignment = .Center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = CGRectMake(0, 0, self.bounds.size.width, self.contentView.bounds.size.height)
    }
    
}
