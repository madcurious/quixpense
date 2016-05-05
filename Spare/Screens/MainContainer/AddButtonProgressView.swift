//
//  AddButtonProgressView.swift
//  Spare
//
//  Created by Matt Quiros on 05/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

protocol AddButtonProgressViewDelegate {
    func progressViewDidCancel()
    func progressViewDidComplete()
}

class AddButtonProgressView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var circleView: __ABCircleView!
    
    @IBOutlet weak var actionLabelY: NSLayoutConstraint!
    @IBOutlet weak var circleViewY: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        
        self.backgroundView.backgroundColor = Color.Black
        
        self.actionLabel.textColor = Color.White
        self.actionLabel.font = Font.text(.Light, size: 14)
        self.actionLabel.text = "NEW CATEGORY"
        self.actionLabel.sizeToFit()
        
        self.reset(animated: false, completion: nil)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func reset(animated animated: Bool = true, completion: (Void -> Void)?) {
        self.backgroundView.alpha = 0
        self.actionLabelY.constant = 0
        self.circleViewY.constant = 0
        
        completion?()
    }
    
    func animate() {
        
        print("circleView: \(self.circleView)")
        print("label: \(self.actionLabel)")
        print("------")
        
        UIView.animateWithDuration(
            0.1,
            animations: {[unowned self] in
                self.backgroundView.alpha = 0.3
                self.actionLabelY.constant = -(self.circleView.bounds.size.height * 0.5 + 20 + self.actionLabel.bounds.size.height)
                self.circleViewY.constant = -(self.circleView.bounds.size.height * 0.5)
            },
            completion: {[unowned self] _ in
                print("circleView: \(self.circleView)")
                print("label: \(self.actionLabel)")
        })
    }
    
}

class __ABCircleView: UIView {
    
//    override func drawRect(rect: CGRect) {
//        <#code#>
//    }
    
}
