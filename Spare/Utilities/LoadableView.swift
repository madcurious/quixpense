//
//  LoadableView.swift
//  Spare
//
//  Created by Matt Quiros on 17/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class LoadableView: UIView {
    
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let errorLabel = UILabel(frame: .zero)
    let dataViewContainer = UIView(frame: .zero)
    
    var state = MDLoadableViewController.State.initial {
        didSet {
            self.loadingView.isHidden = self.state != .initial || self.state != .loading
            if self.state == .initial || self.state == .loading {
                self.loadingView.startAnimating()
            } else {
                self.loadingView.stopAnimating()
            }
            
            self.dataViewContainer.isHidden = self.state != .data
            
            if case .error(let error) = self.state {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error.localizedDescription
            } else {
                self.errorLabel.isHidden = true
                self.errorLabel.text = nil
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews(self.loadingView, self.errorLabel, self.dataViewContainer)
        self.addAutolayout()
        
        self.errorLabel.isHidden = true
        self.dataViewContainer.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dataViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rules = [
            "H:|-20-[errorLabel]-20-|",
            "H:|-0-[dataViewContainer]-0-|",
            "V:|-20-[errorLabel]-20-|",
            "V:|-0-[dataViewContainer]-0-|"
        ]
        
        let views = [
            "errorLabel" : self.errorLabel,
            "dataViewContainer" : self.dataViewContainer
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormatArray(rules,
                                                                                metrics: nil,
                                                                                views: views))
        
        self.addConstraints([
            NSLayoutConstraint(item: self.loadingView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self.loadingView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
    }
    
}
