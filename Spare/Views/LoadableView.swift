//
//  LoadableView.swift
//  Spare
//
//  Created by Matt Quiros on 17/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class LoadableView: MDLoadableView {
    
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let infoLabel = UILabel(frame: .zero)
    let dataViewContainer = UIView(frame: .zero)
    
    override var state: MDLoadableView.State {
        didSet {
            self.loadingView.isHidden = self.state != .initial || self.state != .loading
            if self.state == .initial || self.state == .loading {
                self.loadingView.startAnimating()
            } else {
                self.loadingView.stopAnimating()
            }
            
            self.dataViewContainer.isHidden = self.state != .data
            
            if case .error(let error) = self.state {
                self.infoLabel.isHidden = false
                self.infoLabel.text = error.localizedDescription
            } else if case .noData(let someMessage) = self.state {
                self.infoLabel.isHidden = false
                if let stringMessage = someMessage as? String {
                    self.infoLabel.text = stringMessage
                } else if let attributedText = someMessage as? NSAttributedString {
                    self.infoLabel.attributedText = attributedText
                } else {
                    self.infoLabel.text = nil
                }
            } else {
                self.infoLabel.isHidden = true
                self.infoLabel.text = nil
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews(self.loadingView, self.infoLabel, self.dataViewContainer)
        self.addAutolayout()
        
        self.infoLabel.isHidden = true
        self.dataViewContainer.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dataViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rules = [
            "H:|-20-[errorLabel]-20-|",
            "H:|-0-[dataViewContainer]-0-|",
            "V:|-20-[errorLabel]-20-|",
            "V:|-0-[dataViewContainer]-0-|"
        ]
        
        let views = [
            "errorLabel" : self.infoLabel,
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
