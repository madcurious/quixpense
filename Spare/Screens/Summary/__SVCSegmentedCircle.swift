//
//  __SVCSegmentedCircle.swift
//  Spare
//
//  Created by Matt Quiros on 10/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCSegmentedCircle: UIView {
    
    let strokeWidth = CGFloat(20)
    
    var summary: Summary? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let inset = 1 + (self.strokeWidth / 2)
        let insetRect = CGRectInset(rect, inset, inset)
        let context = UIGraphicsGetCurrentContext()
        
        guard let summary = self.summary,
            let expenses = summary.expenses
            else {
                // If there isn't a summary or there are no expenses in it,
                // draw the default gray circle.
                let path = UIBezierPath(ovalInRect: insetRect)
                path.lineWidth = self.strokeWidth
                
                CGContextSetStrokeColorWithColor(context, Color.SummarySegmentedCircleEmptyColor.CGColor)
                path.stroke()
                
                return
        }
    
    }
    
}