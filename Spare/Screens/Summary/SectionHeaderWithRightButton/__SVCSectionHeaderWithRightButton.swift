//
//  __SVCSectionHeaderWithRightButton.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCSectionHeaderWithRightButton: UICollectionReusableView {
    
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    var rightButtonText: String? {
        get {
            return self.rightButton.currentTitle
        }
        set {
            if let text = newValue {
                self.rightButton.setAttributedTitle(
                    NSAttributedString(string: text, attributes: [
                        NSForegroundColorAttributeName : Color.SummarySectionHeaderRightButton,
                        NSFontAttributeName : Font.SummarySectionHeaderRightButton
                        ]), forState: .Normal)
            } else {
                self.rightButton.setTitle(nil, forState: .Normal)
            }
            self.rightButton.sizeToFit()
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sectionLabel.font = Font.SummarySectionHeaderSectionLabel
        self.sectionLabel.numberOfLines = 1
        self.sectionLabel.lineBreakMode = .ByTruncatingTail
        self.sectionLabel.textColor = Color.SummarySectionHeaderSectionLabel
    }
    
}
