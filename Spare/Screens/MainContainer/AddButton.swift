//
//  AddButton.swift
//  Spare
//
//  Created by Matt Quiros on 05/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

protocol AddButtonDelegate {
    func addButtonDidClick()
    func addButtonDidCompleteLongPress()
}

class AddButton: BaseTabButton {
    
    /// The amount of time before a long press is recognized.
    fileprivate let longPressDelay = 0.5
    
    /// The amount of time that a long press should be held to trigger the New Category action.
    fileprivate let longPressRequirement = 0.7
    
    /// The points that the finger is allowed to move during long press, otherwise tracking stops.
    fileprivate let movementThreshold = CGFloat(40)
    
    /// The time when the touch down occurred.
    var touchTime: TimeInterval?
    
    var longPressTime: TimeInterval?
    
    /// The point where the touch down initially occurred.
    var touchPoint: CGPoint?
    
    var progressView = AddButtonProgressView.instantiateFromNib() as AddButtonProgressView
    
    /// Timer for animating the long press progress.
    var progressTimer: Timer?
    
    var delegate: AddButtonDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.iconLabel.text = Icon.MainTabBarAdd.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first
            else {
                return
        }
        self.startTrackingPress(first)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first,
            let touchPoint = self.touchPoint
            else {
                return
        }
        
        // Don't allow the finger to move too much during long press.
        let movePoint = first.location(in: self)
        let deltaX = fabs(movePoint.x - touchPoint.x)
        let deltaY = fabs(movePoint.y - touchPoint.y)
        guard deltaX <= self.movementThreshold
            && deltaY <= self.movementThreshold
            else {
                self.stopTrackingPress()
                return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stopTrackingPress()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Call stopTrackingPress() but do not invoke UIControl actions.
    }
    
    func startTrackingPress(_ touch: UITouch) {
        self.touchTime = Date().timeIntervalSince1970
        self.touchPoint = touch.location(in: self)
        
        self.applyHighlight(true)
        
        self.perform(#selector(showProgressView(_:)), with: NSNumber(value: true as Bool), afterDelay: self.longPressDelay)
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
            let currentTime = Date().timeIntervalSince1970
            switch (currentTime - touchTime) {
            case let x where x < self.longPressDelay:
                // It's just a click.
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showProgressView(_:)), object: NSNumber(value: true as Bool))
                if let delegate = self.delegate {
                    delegate.addButtonDidClick()
                }
                
            default:
                // The long press was recognized. Invalidate the progress timer and remove the progress view.
                if let progressTimer = self.progressTimer {
                    progressTimer.invalidate()
                }
                self.progressTimer = nil
                self.showProgressView(false)
                
            }
        }
        
        self.touchPoint = nil
        self.touchTime = nil
    }
    
    func showProgressView(_ show: NSNumber) {
        let rootVC = md_rootViewController()
        if show.boolValue == true {
            rootVC.view.addSubviewAndFill(self.progressView)
            self.longPressTime = Date().timeIntervalSince1970
            self.progressTimer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        } else {
            self.progressView.removeFromSuperview()
            self.progressView.reset()
        }
    }
    
    func updateProgress() {
        guard let longPressTime = self.longPressTime
            else {
                return
        }
        
        let currentTime = Date().timeIntervalSince1970
        let progress = (currentTime - longPressTime) / self.longPressRequirement
        self.progressView.progress = progress
        
        if progress >= 1.0 {
            self.stopTrackingPress()
            
            if let delegate = self.delegate {
                delegate.addButtonDidCompleteLongPress()
            }
        }
    }
    
}
