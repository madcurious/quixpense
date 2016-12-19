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
    
    @IBOutlet weak var dateLabelContainer: UIView!
    @IBOutlet var dateLabels: [UILabel]!
    
//    fileprivate var barViews = [_HPVCMonthCellBarView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabelContainer.backgroundColor = UIColor.clear
        
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
        
        // Always add 31 bar views. Show or hide the last three later as needed.
        for _ in 0 ..< 31 {
            let barView = _HPVCMonthCellBarView()
            self.barStackView.addArrangedSubview(barView)
            
//            let view = UIView()
//            view.backgroundColor = UIColor.randomColor()
//            self.barStackView.addArrangedSubview(view)
        }
        
        let dates = [1, 8, 15, 22, 29]
        for i in 0 ..< dates.count {
            let label = self.dateLabels[i]
            label.text = "\(dates[i])"
            let centerX = NSLayoutConstraint(item: label,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.barStackView.arrangedSubviews[dates[i] - 1],
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
            self.wrapperView.addConstraint(centerX)
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
            let percentages = chartData.dailyPercentages,
            percentages.contains(where: { $0 > 0 })
            else {
                self.noExpensesLabel.isHidden = false
                return
        }
        
        self.noExpensesLabel.isHidden = true
        
        // Hide or show the last 3 bar views (29, 30, 31) if they are more
        // than the number of days in the month.
        for i in 28 ..< self.barStackView.arrangedSubviews.count {
            if i < percentages.count {
                self.barStackView.arrangedSubviews[i].isHidden = false
            } else {
                self.barStackView.arrangedSubviews[i].isHidden = true
            }
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        for i in 0 ..< percentages.count {
            let barView = self.barStackView.arrangedSubviews[i] as! _HPVCMonthCellBarView
            let percentage = percentages[i]
            barView.height = self.barStackView.bounds.size.height * percentage
        }
        
        if percentages.count >= 29 {
            self.dateLabels.last?.isHidden = false
        } else {
            self.dateLabels.last?.isHidden = true
        }
        
        self.setNeedsLayout()
    }
    
}

fileprivate class _HPVCMonthCellBarView: UIView {
    
    let barView = UIView()
    
    static let width = CGFloat(6)
    
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
        self.backgroundColor = UIColor.clear
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
                               constant: _HPVCMonthCellBarView.width),
            self.heightConstraint
            ])
        
        self.barView.layer.cornerRadius = _HPVCMonthCellBarView.width / 2
    }
    
}
