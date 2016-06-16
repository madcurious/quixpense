//
//  __SVCFooterView.swift
//  Spare
//
//  Created by Matt Quiros on 16/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __SVCFooterView: UICollectionReusableView {
    
    @IBOutlet weak var promptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.promptLabel)
//        self.backgroundColor = UIColor.yellowColor()
        
        let textAttributes = [
            NSForegroundColorAttributeName : Color.SummaryFooterViewTextColor,
            NSFontAttributeName : Font.SummaryFooterViewText
        ]
        let text = NSMutableAttributedString(string: "Press and hold ", attributes: textAttributes)
        text.appendAttributedString(NSAttributedString(string: Icon.Add.rawValue, attributes: [
            NSForegroundColorAttributeName : Color.SummaryFooterViewTextColor,
            NSFontAttributeName : Font.icon(14)
            ]))
        text.appendAttributedString(NSAttributedString(string: " to add a\nnew category.", attributes: textAttributes))
        
        self.promptLabel.attributedText = text
        self.promptLabel.textAlignment = .Center
        self.promptLabel.numberOfLines = 2
        self.promptLabel.lineBreakMode = .ByWordWrapping
    }
    
}