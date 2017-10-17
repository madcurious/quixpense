//
//  LoadableView.swift
//  Spare
//
//  Created by Matt Quiros on 17/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class LoadableView: UIView, BRLoadableView, Themeable {
    
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let infoLabel = UILabel(frame: .zero)
    let dataViewContainer = UIView(frame: .zero)
    
    var state = BRLoadableViewState.initial {
        didSet {
            loadingView.isHidden = state != .initial || state != .loading
            if state == .initial || state == .loading {
                loadingView.startAnimating()
            } else {
                loadingView.stopAnimating()
            }
            
            dataViewContainer.isHidden = state != .data
            
            if case .error(let error) = state {
                infoLabel.isHidden = false
                infoLabel.text = error.localizedDescription
            } else if case .noData(let someMessage) = state {
                infoLabel.isHidden = false
                if let stringMessage = someMessage as? String {
                    infoLabel.text = stringMessage
                    infoLabel.textColor = Global.theme.color(for: .regularText)
                } else if let attributedText = someMessage as? NSAttributedString {
                    infoLabel.attributedText = attributedText
                } else {
                    infoLabel.text = nil
                }
            } else {
                infoLabel.isHidden = true
                infoLabel.text = nil
            }
        }
    }
    
    func applyTheme() {
        backgroundColor = Global.theme.color(for: .mainBackground)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(loadingView, infoLabel, dataViewContainer)
        addAutolayout()
        
        infoLabel.isHidden = true
        dataViewContainer.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        dataViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let rules = [
            "H:|-20-[errorLabel]-20-|",
            "H:|-0-[dataViewContainer]-0-|",
            "V:|-20-[errorLabel]-20-|",
            "V:|-0-[dataViewContainer]-0-|"
        ]
        
        let views = [
            "errorLabel" : infoLabel,
            "dataViewContainer" : dataViewContainer
        ]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormatArray(rules,
                                                                                metrics: nil,
                                                                                views: views))
        
        addConstraints([
            NSLayoutConstraint(item: loadingView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: loadingView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
    }
    
}
