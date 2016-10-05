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
        self.nameLabel.lineBreakMode = .byWordWrapping
        self.nameLabel.textAlignment = .center
        
        self.totalLabel.font = Font.make(.Heavy, 22)
        self.totalLabel.textColor = Color.UniversalTextColor
        self.totalLabel.numberOfLines = 1
        self.totalLabel.lineBreakMode = .byClipping
        self.totalLabel.textAlignment = .center
        
        self.detailLabel.font = Font.make(.Heavy, 22)
        self.detailLabel.textColor = Color.UniversalTextColor
        self.detailLabel.numberOfLines = 0
        self.detailLabel.lineBreakMode = .byWordWrapping
        self.detailLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentView.bounds.size.height)
    }
    
}
