//
//  __SVCSegmentedCircle.swift
//  Spare
//
//  Created by Matt Quiros on 10/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCSegmentedCircle: UIView {
    
    let strokeWidth = CGFloat(14)
    
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
        
        // If there isn't a summary or there are no expenses in it,
        // draw the default gray circle.
        guard let summary = self.summary,
            let info = summary.info
            where summary.expenses?.isEmpty == false
            else {
                let path = UIBezierPath(ovalInRect: insetRect)
                path.lineWidth = self.strokeWidth
                CGContextSetStrokeColorWithColor(context, Color.SummarySegmentedCircleEmptyColor.CGColor)
                path.stroke()
                
                return
        }
        
        let arcCenter = CGPointMake(rect.size.width / 2, rect.size.height / 2)
        let radius = insetRect.size.width / 2
        var lastAngle = CGFloat(-1 * M_PI_2)
        for (category, _, percent) in info {
            let path = UIBezierPath(arcCenter: arcCenter, radius: radius,
                                    startAngle: lastAngle, endAngle: lastAngle + CGFloat(2 * M_PI * percent), clockwise: true)
            path.lineWidth = self.strokeWidth
            CGContextSetStrokeColorWithColor(context, category.color.CGColor)
            path.stroke()
            
            lastAngle = lastAngle + CGFloat(2 * M_PI * percent)
        }
    }
    
}