//
//  AddButton.swift
//  Spare
//
//  Created by Matt Quiros on 05/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class AddButton: BaseTabButton {
    
    /// The amount of time before a long press is recognized.
    private let longPressDelay = 0.5
    
    /// The amount of time that a long press should be held to trigger the New Category action.
    private let longPressRequirement = 0.5
    
    private let movementThreshold = CGFloat(10)
    
    /// The time when the touch occurred.
    var touchTime: NSTimeInterval?
    
    /// The point where the touch initially occurred
    var touchPoint: CGPoint?
    
    var progressView = AddButtonProgressView.instantiateFromNib() as AddButtonProgressView
    
    init() {
        super.init(frame: CGRectZero)
        
        self.iconLabel.text = Icon.Add.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let first = touches.first
            else {
                return
        }
        self.startTrackingPress(first)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let first = touches.first,
            let touchPoint = self.touchPoint
            else {
                return
        }
        
        // Don't allow the finger to move too much during long press.
        let movePoint = first.locationInView(self)
        let deltaX = fabs(movePoint.x - touchPoint.x)
        let deltaY = fabs(movePoint.y - touchPoint.y)
        guard deltaX <= self.movementThreshold
            && deltaY <= self.movementThreshold
            else {
                self.stopTrackingPress()
                return
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.stopTrackingPress()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // Call stopTrackingPress() but do not invoke UIControl actions.
    }
    
    func startTrackingPress(touch: UITouch) {
        self.touchTime = NSDate().timeIntervalSince1970
        self.touchPoint = touch.locationInView(self)
        
        self.applyHighlight(true)
        
        self.performSelector(#selector(showLongPressProgressView(_:)), withObject: NSNumber(bool: true), afterDelay: self.longPressDelay)
    }
    
    func stopTrackingPress() {
        // Do nothing if the function is invoked when the user lifts the finger
        // after the long press has already finished tracking touches.
        guard self.touchPoint != nil && self.touchTime != nil
            else {
                return
        }
        
        self.applyHighlight(false)
        
        if let touchTime = self.touchTime {
            let currentTime = NSDate().timeIntervalSince1970
            switch (currentTime - touchTime) {
            case let x where x < self.longPressDelay:
                () // It's just a click.
                NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(showLongPressProgressView(_:)), object: NSNumber(bool: true))
                
            default:
                // It was a long press; dismiss the dialog.
                self.showLongPressProgressView(NSNumber(bool: false))
                
            }
        }
        
        self.touchPoint = nil
        self.touchTime = nil
    }
    
    func showLongPressProgressView(flag: NSNumber) {
        let rootVC = rootViewController()
        
        if flag.boolValue == true {
            rootVC.view.addSubviewAndFill(self.progressView)
            self.progressView.animate()
        }
        
        else {
            self.progressView.reset {[unowned self] in
                self.progressView.removeFromSuperview()
            }
        }
    }
    
}
