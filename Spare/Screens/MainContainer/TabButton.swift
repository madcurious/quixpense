//
//  TabButton.swift
//  Spare
//
//  Created by Matt Quiros on 04/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

protocol TabButtonDelegate {
    
    func tabButtonDidSelect(tabButton: TabButton)
    
}

class TabButton: UIControl {
    
    let backgroundView = UIView()
    let iconLabel = UILabel()
    
    var delegate: TabButtonDelegate?
    
    override var highlighted: Bool {
        willSet {
            self.applyHighlight(newValue)
        }
    }
    
    override var selected: Bool {
        willSet {
            self.applySelection(newValue)
        }
    }
    
    init(_ icon: Icon) {
        super.init(frame: CGRectZero)
        
        UIView.clearBackgroundColors(self, self.backgroundView, self.iconLabel)
        self.addSubviewsAndFill(self.backgroundView, self.iconLabel)
        
        // Prevent subviews from intercepting events.
        self.iconLabel.userInteractionEnabled = false
        self.backgroundView.userInteractionEnabled = false
        
        self.iconLabel.text = icon.rawValue
        self.iconLabel.font = Font.icon(28)
        self.iconLabel.textColor = Color.Gray700
        self.iconLabel.textAlignment = .Center
        
        self.addTarget(self, action: #selector(enableHighlight), forControlEvents: [.TouchDown, .TouchDragEnter, .TouchDragInside])
        self.addTarget(self, action: #selector(disableHighlight), forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragExit, .TouchDragOutside])
        self.addTarget(self, action: #selector(enableSelection), forControlEvents: .TouchUpInside)
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
            
            self.iconLabel.textColor = Color.Gray200
            self.iconLabel.alpha = 0.7
        } else {
            self.iconLabel.textColor = Color.Gray700
            self.iconLabel.alpha = 1.0
        }
    }
    
    func enableHighlight() {
        self.highlighted = true
    }
    
    func disableHighlight() {
        self.highlighted = false
    }
    
    func applySelection(selected: Bool) {
        if selected {
            self.backgroundView.backgroundColor = Color.Gray200
            
            if let delegate = self.delegate {
                delegate.tabButtonDidSelect(self)
            }
        } else {
            self.backgroundView.backgroundColor = UIColor.clearColor()
        }
    }
    
    func enableSelection() {
        self.selected = true
    }
    
    func disableSelection() {
        self.selected = false
    }
    
}
