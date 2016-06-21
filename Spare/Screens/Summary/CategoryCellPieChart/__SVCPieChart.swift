//
//  __SVCPieChart.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __SVCPieChart: UIView {
    
    var percent = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let inset = CGFloat(1)
        let insetRect = CGRectInset(rect, inset, inset)
        let context = UIGraphicsGetCurrentContext()
        
        let borderPath = UIBezierPath(ovalInRect: insetRect)
        borderPath.lineWidth = 1
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        borderPath.stroke()
        
        let arcCenter = CGPointMake(rect.width / 2, rect.height / 2)
        let startAngle = CGFloat(-1 * M_PI_2)
        let endAngle = startAngle + CGFloat(2 * M_PI * self.percent)
        let pieArc = UIBezierPath(arcCenter: arcCenter, radius: insetRect.width / 2,
                                  startAngle: startAngle, endAngle: endAngle, clockwise: true)
        pieArc.addLineToPoint(arcCenter)
        pieArc.closePath()
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        pieArc.fill()
    }
    
}
