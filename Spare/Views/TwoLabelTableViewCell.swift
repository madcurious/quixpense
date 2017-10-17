//
//  TwoLabelTableViewCell.swift
//  Spare
//
//  Created by Matt Quiros on 18/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class TwoLabelTableViewCell: UITableViewCell, Themeable {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.contentView.backgroundColor = Global.theme.color(for: .mainBackground)
        
        self.leftLabel.font = Global.theme.font(for: .regularText)
        self.leftLabel.textColor = Global.theme.color(for: .regularText)
        self.leftLabel.numberOfLines = 1
        self.leftLabel.lineBreakMode = .byTruncatingTail
        
        self.rightLabel.font = Global.theme.font(for: .regularText)
        self.rightLabel.textColor = Global.theme.color(for: .regularText)
        self.rightLabel.numberOfLines = 1
        
        self.disclosureIndicatorImageView.image = UIImage.template(named: "disclosureIndicator")
        self.disclosureIndicatorImageView.tintColor = Global.theme.color(for: .disclosureIndicator)
    }
    
}
