//
//  Value1TableViewCell.swift
//  Spare
//
//  Created by Matt Quiros on 17/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class Value1TableViewCell: UITableViewCell, Themeable {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.accessoryType = .disclosureIndicator
        self.applyTheme()
    }
    
    func applyTheme() {
        self.contentView.backgroundColor = Global.theme.color(for: .mainBackground)
        
        guard let leftLabel = self.textLabel,
            let rightLabel = self.detailTextLabel
            else {
                return
        }
        
        leftLabel.font = Global.theme.font(for: .regularText)
        leftLabel.textColor = Global.theme.color(for: .regularText)
        leftLabel.setContentCompressionResistancePriority(250, for: .horizontal)
        leftLabel.lineBreakMode = .byTruncatingTail
        leftLabel.numberOfLines = 1
        leftLabel.adjustsFontSizeToFitWidth = true
        
        rightLabel.font = Global.theme.font(for: .regularText)
        rightLabel.textColor = Global.theme.color(for: .regularText)
        rightLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
    }
    
}
