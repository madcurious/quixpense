//
//  _HPVCBarView.swift
//  Spare
//
//  Created by Matt Quiros on 19/12/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class _HPVCBarView: UIView {
    
    let barView = UIView()
    
    static let width = CGFloat(6)
    
    var height: CGFloat {
        get {
            return self.heightConstraint.constant
        }
        set {
            self.heightConstraint.constant = newValue
            self.setNeedsLayout()
        }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
        self.barView.backgroundColor = UIColor(hex: 0xd8d8d8)
        self.addSubview(self.barView)
        
        self.barView.translatesAutoresizingMaskIntoConstraints = false
        self.heightConstraint = NSLayoutConstraint(item: self.barView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 0)
        
        self.addConstraints([
            NSLayoutConstraint(item: self.barView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self.barView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self.barView,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: _HPVCBarView.width),
            self.heightConstraint
            ])
        
        self.barView.layer.cornerRadius = _HPVCBarView.width / 2
    }
    
}
