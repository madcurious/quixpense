//
//  OperationVCLoadingView.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class OperationVCLoadingView: UIView {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override var isHidden: Bool {
        didSet {
            if self.isHidden == true {
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = Color.UniversalBackgroundColor
        self.addSubview(self.activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            NSLayoutConstraint(item: self.activityIndicator,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.activityIndicator,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0)
        ]
        self.addConstraints(constraints)
        self.setNeedsLayout()
    }
    
}
