//
//  _HPVCMonthCell.swift
//  Spare
//
//  Created by Matt Quiros on 16/12/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kCenterConstraintID = "kCenterConstraintID"

class _HPVCMonthCell: _HPVCChartCell {
    
    @IBOutlet weak var dailyAverageLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet var dateLabels: [UILabel]!
    
    fileprivate var barViews = [_HPVCMonthCellBarView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dailyAverageLabel.font = Font.make(.regular, 12)
        self.dailyAverageLabel.textColor = Color.UniversalTextColor
        self.dailyAverageLabel.numberOfLines = 1
        self.dailyAverageLabel.lineBreakMode = .byTruncatingTail
        
        self.percentageLabel.font = Font.make(.regular, 12)
        self.percentageLabel.textColor = Color.UniversalTextColor
        self.percentageLabel.numberOfLines = 1
        self.percentageLabel.lineBreakMode = .byTruncatingTail
        
        var dateLabel = 1
        for label in self.dateLabels {
            label.font = Font.make(.regular, 11)
            label.textColor = Color.UniversalTextColor
            label.textAlignment = .center
            label.text = "\(dateLabel)"
            
            dateLabel += 7
        }
    }
    
    override func update(withData chartData: ChartData?, drawGraph: Bool) {
        super.update(withData: chartData, drawGraph: drawGraph)
        
        guard let chartData = chartData
            else {
                return
        }
        
        self.dailyAverageLabel.text = "Daily average: \(AmountFormatter.displayText(for: chartData.dailyAverage))"
        self.percentageLabel.text = "\(PercentFormatter.displayText(for: chartData.ratio)) of total"
        
        guard drawGraph == true,
            let percentages = chartData.dailyPercentages
            else {
            return
        }
        
        switch barViews.count {
        case 0:
            self.addBarViews(quantity: 28)
            fallthrough
            
        default:
            if barViews.count < percentages.count {
                self.addBarViews(quantity: percentages.count - barViews.count)
            } else if percentages.count < barViews.count {
                self.removeBarViews(quantity: barViews.count - percentages.count)
            }
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        for i in 0 ..< percentages.count {
            let barView = self.barViews[i]
            let percentage = percentages[i]
            barView.height = self.barStackView.bounds.size.height * percentage
        }
        
        guard let dates = chartData.dates
            else {
                return
        }
        
        // Hide the last date label if there are only 4 dates to be displayed.
        if dates.count < self.dateLabels.count {
            self.dateLabels.last?.isHidden = true
        } else {
            self.dateLabels.last?.isHidden = false
        }
        
        for i in 0 ..< dates.count {
            let label = self.dateLabels[i]
            
            // Add a center constraint to the label if not previously added.
            guard label.constraints.first(where: { $0.identifier == kCenterConstraintID }) != nil
                else {
                    let centerX = NSLayoutConstraint(item: label,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: self.barViews[dates[i - 1]],
                                                     attribute: .centerX,
                                                     multiplier: 1,
                                                     constant: 0)
                    label.addConstraint(centerX)
                    continue
            }
        }
        
        self.setNeedsLayout()
    }
    
    func addBarViews(quantity: Int) {
        for _ in 0 ..< quantity {
            let barView = _HPVCMonthCellBarView()
            barView.backgroundColor = UIColor.clear
            self.barStackView.addArrangedSubview(barView)
        }
    }
    
    func removeBarViews(quantity: Int) {
        for _ in 0 ..< quantity {
            if let lastBarView = self.barStackView.arrangedSubviews.last {
                self.barStackView.removeArrangedSubview(lastBarView)
                lastBarView.removeFromSuperview()
            }
        }
    }
    
}

fileprivate class _HPVCMonthCellBarView: UIView {
    
    let barView = UIView()
    
    var height: CGFloat {
        get {
            return self.heightConstraint.constant
        }
        set {
            self.heightConstraint.constant = newValue
            self.setNeedsLayout()
        }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.barView.backgroundColor = UIColor(hex: 0xd8d8d8)
        self.addSubview(self.barView)
        
        self.barView.translatesAutoresizingMaskIntoConstraints = false
        self.heightConstraint = NSLayoutConstraint(item: self.barView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1,
                                                   constant: 0)
        
        self.addConstraints([
            NSLayoutConstraint(item: self.barView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self.barView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self.barView,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: 0),
            self.heightConstraint
            ])
    }
    
}
