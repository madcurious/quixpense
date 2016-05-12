//
//  FieldButton.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class FieldButton: UIControl {
    
    var placeholder = NSAttributedString(
        string: Strings.FieldPlaceholder,
        attributes: [
            NSForegroundColorAttributeName : Color.FormPlaceholderTextColor,
            NSFontAttributeName : Font.FieldValue
        ])
    var value: Any?
    var valueText: String?
    
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}