//
//  Button.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class Button: UIControl {
    
    override var highlighted: Bool {
        didSet {
            UIView.animateWithDuration(0.2) {[unowned self] in
                self.alpha = self.highlighted ? 0.1 : 1.0
            }
        }
    }
    
    let label = UILabel()
    
    init() {
        super.init(frame: CGRectZero)
        self.addSubviewAndFill(self.label)
    }
    
    override func sizeToFit() {
        self.label.sizeToFit()
        self.frame = self.label.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}