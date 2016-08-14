//
//  BaseTabButton.swift
//  Spare
//
//  Created by Matt Quiros on 05/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class BaseTabButton: UIControl {
    
    let backgroundView = UIView()
    let iconLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UIView.clearBackgroundColors(self, self.backgroundView, self.iconLabel)
        self.addSubviewsAndFill(self.backgroundView, self.iconLabel)
        
        // Prevent subviews from intercepting events.
        self.iconLabel.userInteractionEnabled = false
        self.backgroundView.userInteractionEnabled = false
        
        self.iconLabel.font = Font.icon(28)
        self.iconLabel.textColor = Color.UniversalTextColor
        self.iconLabel.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyHighlight(highlighted: Bool) {
        if highlighted {
            // You can't highlight if the button is selected.
            if self.selected == true {
                return
            }
            
            self.iconLabel.alpha = 0.5
        }
        
        else {
            self.iconLabel.alpha = 1.0
        }
    }
    
    func applySelection(selected: Bool) {
        if selected {
            self.backgroundView.backgroundColor = Color.TabButtonSelectedBackgroundColor
        } else {
            self.backgroundView.backgroundColor = UIColor.clearColor()
        }
    }
    
}
