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
    
//    let backgroundView = UIVisualEffectView(effect: UIBlurEffect())
    let backgroundView = UIView()
    let label = UILabel()
    let circleView = __ABCircleView()
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        
        self.backgroundView.backgroundColor = Color.Black
        self.addSubviewAndFill(self.backgroundView)
        
        self.label.textColor = Color.White
        self.label.font = Font.text(.Light, size: 14)
        self.label.text = "NEW CATEGORY"
        self.label.sizeToFit()
        self.addSubview(self.label)
        
        self.reset(animated: false, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset(animated animated: Bool = true, completion: (Void -> Void)?) {
        self.backgroundView.alpha = 0
        
        // Situate at the bottom.
        self.label.frame.origin = CGPoint(x: self.bounds.width / 2 - self.label.bounds.width / 2,
                                          y: self.bounds.height)
        self.circleView.frame.origin = CGPoint(x: self.bounds.width / 2 - self.circleView.bounds.width / 2,
                                               y: self.bounds.height)
        
        completion?()
    }
    
    func animate() {
        
        print("circleView: \(self.circleView)")
        print("label: \(self.label)")
        print("------")
        
        UIView.animateWithDuration(
            0.1,
            animations: {[unowned self] in
                self.backgroundView.alpha = 0.3
                
                self.circleView.frame.offsetInPlace(dx: 0, dy: self.circleView.bounds.height * -0.6)
                self.label.frame.offsetInPlace(dx: 0, dy: (self.circleView.bounds.height * 0.6 + 20 + self.label.bounds.size.height))
            },
            completion: {[unowned self] _ in
                print("circleView: \(self.circleView)")
                print("label: \(self.label)")
        })
    }
    
}

class __ABCircleView: UIView {
    
    init() {
        let side = UIScreen.mainScreen().bounds.size.width * 0.4
        super.init(frame: CGRectMake(0, 0, side, side))
        
        self.backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
            else {
                return
        }
        
        
    }
    
}
