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
    
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var circleView: __ABCircleView!
    
    var progress: Double {
        get {
            return self.circleView.progress
        }
        set {
            self.circleView.progress = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        
        self.backgroundView.effect = UIBlurEffect(style: .Dark)
        
        self.actionLabel.textColor = Color.White
        self.actionLabel.font = Font.text(.Light, size: 14)
        self.actionLabel.text = "NEW CATEGORY"
        self.actionLabel.sizeToFit()
        
        self.reset()
    }
    
    func reset() {
        self.progress = 0.0
    }
    
}

class __ABCircleView: UIView {
    
    var progress = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private let startingProgress = 0.2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = Color.White.CGColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        var components = [CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0)]
        Color.White.getRed(&components[0], green: &components[1], blue: &components[2], alpha: &components[3])
        CGContextSetRGBFillColor(context, components[0], components[1], components[2], components[3])
        
        let inset = (rect.width - (rect.width * CGFloat(self.startingProgress + (1 - self.startingProgress) * self.progress))) / 2
        let fillRect = CGRectInset(rect, inset, inset)
        
        CGContextFillEllipseInRect(context, fillRect)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.height / 2
        super.layoutSubviews()
    }
    
}
