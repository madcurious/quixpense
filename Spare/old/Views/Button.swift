//
//  Button.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class Button: UIControl {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {[unowned self] in
                self.alpha = self.isHighlighted ? 0.1 : 1.0
            }) 
        }
    }
    
    let label = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubviewAndFill(self.label)
    }
    
    convenience init(string: String, font: UIFont, textColor: UIColor) {
        self.init()
        self.label.attributedText = NSAttributedString(string: string, font: font, textColor: textColor)
        self.sizeToFit()
    }
    
    override func sizeToFit() {
        self.label.sizeToFit()
        self.frame = CGRect(x: self.frame.origin.x,
                            y: self.frame.origin.y,
                            width: self.label.bounds.size.width,
                            height: self.label.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
