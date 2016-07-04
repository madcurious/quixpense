//
//  CustomBarButton.swift
//  Spare
//
//  Created by Matt Quiros on 27/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomBarButton: UIControl {
    
    let label = UILabel()
    var texts = [UIControlState : AnyObject]()
    
    override var highlighted: Bool {
        didSet {
            self.applyHighlight(self.highlighted)
        }
    }
    
    override var enabled: Bool {
        didSet {
            self.applyEnabled(self.enabled)
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.addSubviewsAndFill(self.label)
    }
    
    convenience init(attributedText: NSAttributedString) {
        self.init()
        
        self.texts[.Normal] = attributedText
        
        let disabledText = NSMutableAttributedString(attributedString: attributedText)
        disabledText.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, disabledText.length))
        disabledText.addAttributes([
            NSForegroundColorAttributeName : Color.CustomBarButtonDisabled
            ], range: NSMakeRange(0, disabledText.length))
        self.texts[.Disabled] = disabledText
        
        self.label.attributedText = attributedText
        self.label.sizeToFit()
        self.frame = CGRectMake(0, 0, self.label.bounds.size.width, self.label.bounds.size.height)
    }
    
    func applyHighlight(highlighted: Bool) {
        if highlighted {
            self.label.alpha = 0.2
        } else {
            self.label.alpha = 1.0
        }
    }
    
    func applyEnabled(enabled: Bool) {
        if enabled == false {
            if let disabledText = self.texts[.Disabled] as? NSAttributedString {
                self.label.attributedText = disabledText
            }
            self.label.alpha = 0.4
        } else {
            self.label.attributedText = self.texts[.Normal] as? NSAttributedString
            self.label.alpha = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIControlState: Hashable {
    
    public var hashValue: Int {
        return Int(self.rawValue)
    }
    
}