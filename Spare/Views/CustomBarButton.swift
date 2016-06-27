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
    
    init() {
        super.init(frame: CGRectZero)
        self.addSubviewsAndFill(self.label)
        
        self.addObserver(self, forKeyPath: "highlighted", options: [.New], context: nil)
    }
    
    convenience init(attributedText: NSAttributedString) {
        self.init()
        self.label.attributedText = attributedText
        self.label.sizeToFit()
        self.frame = CGRectMake(0, 0, self.label.bounds.size.width, self.label.bounds.size.height)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard keyPath == "highlighted"
            else {
                return
        }
        self.applyHighlight(self.highlighted)
    }
    
    func applyHighlight(highlighted: Bool) {
        if highlighted {
            self.label.alpha = 0.2
        } else {
            self.label.alpha = 1.0
        }
    }
    
    func handleHighlightChangeOnButton(button: CustomBarButton) {
        self.applyHighlight(button.highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "highlighted")
    }

    
}
