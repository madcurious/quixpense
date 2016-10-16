//
//  SegmentedCircle.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class SegmentedCircle: UIView {
    
    let strokeWidth = CGFloat(10)
    
    var segments: [(Category, NSDecimalNumber, Double)]? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let inset = 1 + (self.strokeWidth / 2)
        let insetRect = rect.insetBy(dx: inset, dy: inset)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the empty gray path.
        let path = UIBezierPath(ovalIn: insetRect)
        path.lineWidth = self.strokeWidth
        context?.setStrokeColor(UIColor(hex: 0x444444).cgColor)
        path.stroke()
        
        // Draw the segments.
        guard let segments = self.segments
            else {
                return
        }
        let arcCenter = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = insetRect.size.width / 2
        var lastAngle = CGFloat(-1 * M_PI_2)
        for (category, _, percent) in segments {
            let path = UIBezierPath(arcCenter: arcCenter, radius: radius,
                                    startAngle: lastAngle, endAngle: lastAngle + CGFloat(2 * M_PI * percent), clockwise: true)
            path.lineWidth = self.strokeWidth
            context?.setStrokeColor(category.color.cgColor)
            path.stroke()
            
            lastAngle = lastAngle + CGFloat(2 * M_PI * percent)
        }
    }
    
}

