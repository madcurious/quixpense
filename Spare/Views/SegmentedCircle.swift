//
//  SegmentedCircle.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class SegmentedCircle: UIView {
    
    let strokeWidth = CGFloat(6)
    
    var segments: [(Category, NSDecimalNumber, Double)]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let inset = 1 + (self.strokeWidth / 2)
        let insetRect = CGRectInset(rect, inset, inset)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the empty gray path.
        let path = UIBezierPath(ovalInRect: insetRect)
        path.lineWidth = self.strokeWidth
        CGContextSetStrokeColorWithColor(context, Color.SegmentedCircleEmptyColor.CGColor)
        path.stroke()
        
        // Draw the segments.
        guard let segments = self.segments
            else {
                return
        }
        let arcCenter = CGPointMake(rect.size.width / 2, rect.size.height / 2)
        let radius = insetRect.size.width / 2
        var lastAngle = CGFloat(-1 * M_PI_2)
        for (category, _, percent) in segments {
            let path = UIBezierPath(arcCenter: arcCenter, radius: radius,
                                    startAngle: lastAngle, endAngle: lastAngle + CGFloat(2 * M_PI * percent), clockwise: true)
            path.lineWidth = self.strokeWidth
            CGContextSetStrokeColorWithColor(context, category.color.CGColor)
            path.stroke()
            
            lastAngle = lastAngle + CGFloat(2 * M_PI * percent)
        }
    }
    
}

