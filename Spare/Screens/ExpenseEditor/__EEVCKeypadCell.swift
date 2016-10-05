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
                , text == Icon.ExpenseEditorBackspace.rawValue {
                self.keyLabel.font = Font.icon(Font.AnySize)
            } else {
                self.keyLabel.font = Font.ExpenseEditorKeypadText
            }
            self.keyLabel.text = self.text
            self.setNeedsLayout()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.contentView.backgroundColor = self.isHighlighted ? Color.KeypadHighlightedBackgroundColor : UIColor.clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviewAndFill(self.keyLabel)
        
        self.keyLabel.fontSize = .VHeight(0.5)
        self.keyLabel.textColor = Color.UniversalTextColor
        self.keyLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
