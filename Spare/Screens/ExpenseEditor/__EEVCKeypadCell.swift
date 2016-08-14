//
//  __EEVCKeypadCell.swift
//  Spare
//
//  Created by Matt Quiros on 13/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __EEVCKeypadCell: UICollectionViewCell {
    
    let keyLabel = MDResponsiveLabel()
    
    var text: String? {
        didSet {
            if let text = self.text
                where text == Icon.ExpenseEditorBackspace.rawValue {
                self.keyLabel.font = Font.icon(Font.AnySize)
            } else {
                self.keyLabel.font = Font.ExpenseEditorKeypadText
            }
            self.keyLabel.text = self.text
            self.setNeedsLayout()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.backgroundColor = self.highlighted ? Color.KeypadHighlightedBackgroundColor : Color.KeypadBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviewAndFill(self.keyLabel)
        
        self.keyLabel.fontSize = .VHeight(0.5)
        self.keyLabel.textColor = Color.UniversalTextColor
        self.keyLabel.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
