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
    
    func tabButtonDidSelect(_ tabButton: TabButton)
    
}

class TabButton: BaseTabButton {
    
    var delegate: TabButtonDelegate?
    
    override var isHighlighted: Bool {
        willSet {
            self.applyHighlight(newValue)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            self.applySelection(newValue)
        }
    }
    
    init(_ icon: Icon) {
        super.init(frame: CGRect.zero)
        
        self.iconLabel.text = icon.rawValue
        
        self.addTarget(self, action: #selector(enableHighlight), for: [.touchDown, .touchDragEnter, .touchDragInside])
        self.addTarget(self, action: #selector(disableHighlight), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchDragOutside])
        self.addTarget(self, action: #selector(enableSelection), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableHighlight() {
        self.isHighlighted = true
    }
    
    func disableHighlight() {
        self.isHighlighted = false
    }
    
    override func applySelection(_ selected: Bool) {
        super.applySelection(selected)
        
        if let delegate = self.delegate
            , selected == true {
            delegate.tabButtonDidSelect(self)
        }
    }
    
    func enableSelection() {
        self.isSelected = true
    }
    
}
