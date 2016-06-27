//
//  IconBarButton.swift
//  Spare
//
//  Created by Matt Quiros on 27/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class IconBarButton: UIControl {
    
    let iconLabel = UILabel()
    
    var icon: Icon? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            guard let icon = self.icon
                else {
                    self.iconLabel.text = nil
                    return
            }
            
            self.iconLabel.text = icon.rawValue
        }
    }
    
    var fontSize: CGFloat {
        get {
            return self.iconLabel.font.pointSize
        }
        set {
            self.iconLabel.font = Font.icon(newValue)
        }
    }
    
    init(size: CGSize) {
        super.init(frame: CGRectMake(0, 0, size.width, size.height))
        
        self.iconLabel.font = Font.icon(30)
        self.iconLabel.textColor = UIColor.whiteColor()
        self.iconLabel.numberOfLines = 1
        self.iconLabel.lineBreakMode = .ByTruncatingTail
        self.addSubviewAndFill(self.iconLabel)
        
        self.applyHighlight(false)
        
        self.addObserver(self, forKeyPath: "highlighted", options: [.New], context: nil)
    }
    
    convenience init() {
        self.init(size: CGSizeMake(30, 30))
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
            self.iconLabel.alpha = 0.2
        } else {
            self.iconLabel.alpha = 1.0
        }
    }
    
    func handleHighlightChangeOnButton(button: IconBarButton) {
        self.applyHighlight(button.highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "highlighted")
    }
    
}