//
//  TabButton.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class TabButton: UIControl {
    
    enum Icon {
        case Home, Add, Settings
        
        func attributedString(size: CGFloat, color: UIColor) -> NSAttributedString {
            let attributes = [
                NSForegroundColorAttributeName : color,
                NSFontAttributeName : Font.icon(size)
            ]
            switch self {
            case .Home:
                return NSAttributedString(string: "b", attributes: attributes)
                
            case .Add:
                return NSAttributedString(string: "f", attributes: attributes)
                
            case .Settings:
                return NSAttributedString(string: "j", attributes: attributes)
            }
        }
    }
    
    let backgroundView = UIView()
    let iconLabel = UILabel()
    
    init(_ icon: Icon) {
        super.init(frame: CGRectZero)
        
        UIView.clearBackgroundColors(self, self.backgroundView, self.iconLabel)
        self.addSubviewsAndFill(self.backgroundView, self.iconLabel)
        
        self.iconLabel.attributedText = icon.attributedString(28, color: Color.Gray7)
        self.iconLabel.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
