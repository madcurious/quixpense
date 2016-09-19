//
//  OperationVCLoadingView.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class OperationVCLoadingView: UIView {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    override var hidden: Bool {
        didSet {
            if self.hidden == true {
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
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
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.activityIndicator,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0)
        ]
        self.addConstraints(constraints)
        self.setNeedsLayout()
    }
    
}
