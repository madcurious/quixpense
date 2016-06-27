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

class TabButton: BaseTabButton {
    
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
        
        self.iconLabel.text = icon.rawValue
        
        self.addTarget(self, action: #selector(enableHighlight), forControlEvents: [.TouchDown, .TouchDragEnter, .TouchDragInside])
        self.addTarget(self, action: #selector(disableHighlight), forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragExit, .TouchDragOutside])
        self.addTarget(self, action: #selector(enableSelection), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableHighlight() {
        self.highlighted = true
    }
    
    func disableHighlight() {
        self.highlighted = false
    }
    
    override func applySelection(selected: Bool) {
        super.applySelection(selected)
        
        if let delegate = self.delegate
            where selected == true {
            delegate.tabButtonDidSelect(self)
        }
    }
    
    func enableSelection() {
        self.selected = true
    }
    
}
