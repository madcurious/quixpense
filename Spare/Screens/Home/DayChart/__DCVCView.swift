//
//  __DCVCView.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __DCVCView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var graphBackgroundContainer: UIView!
    let graphBackground = GraphBackground.instantiateFromNib()
    
    @IBOutlet weak var pieChartContainer: UIView!
    @IBOutlet weak var pieView: PieView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var category: Category? {
        didSet {
            if let category = self.category {
                self.nameLabel.text = category.name
            } else {
                self.nameLabel.text = "..."
            }
            self.setNeedsLayout()
        }
    }
    
    var data: (total: NSDecimalNumber, percent: Double)? {
        didSet {
            if let data = self.data {
                self.totalLabel.text = AmountFormatter.displayText(for: data.total)
                self.percentLabel.text = PercentFormatter.displayTextForPercent(data.percent)
                
                if data.total == 0 {
                    
                }
            }
            else {
                self.totalLabel.text = "..."
                self.percentLabel.text = "..."
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.graphContainer,
            self.graphBackgroundContainer,
            self.graphBackground,
            self.pieChartContainer,
            self.pieView
        )
        self.backgroundColor = UIColor(hex: 0x333333)
        
        self.graphBackgroundContainer.addSubviewAndFill(self.graphBackground)
        
        self.emptyLabel.text = "No expenses"
        
        self.percentLabel.textColor = Color.UniversalTextColor
        self.percentLabel.font = Font.make(.Book, 14)
    }
    
}

class PieView: UIView {
    
    var percent = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
            else {
                return
        }
        
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let insetRect = rect.insetBy(dx: 1, dy: 1)
        let radius = insetRect.height / 2
        let startAngle = CGFloat(M_PI_2)
        let endAngle = startAngle + CGFloat(2 * M_PI * self.percent)
        
        let fillPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0xd8d8d8).cgColor)
        fillPath.fill()
        
        let emptyPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        context.setFillColor(UIColor(hex: 0x4e4e4e).cgColor)
        emptyPath.fill()
    }
    
}
