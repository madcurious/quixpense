//
//  __HVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 29/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCCell: UICollectionViewCell {
    
    static let garbageSummaryValue: Summary = {
        let currentDate = NSDate()
        return Summary(startDate: currentDate.firstMoment(), endDate: currentDate.lastMoment(), periodization: .Day)
    }()
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var summaryVCContainer: UIView!
    @IBOutlet var borderConstraints: [NSLayoutConstraint]!
    
    let summaryVC = SummaryVC(summary: __HVCCell.garbageSummaryValue)
    var summary: Summary? {
        get {
            return self.summaryVC.summary
        }
        set {
            self.summaryVC.summary = newValue ?? __HVCCell.garbageSummaryValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.borderView.backgroundColor = Color.HomeCellBorderColor
        
        self.summaryVCContainer.addSubviewAndFill(self.summaryVC.view)
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        for constraint in self.borderConstraints {
            constraint.constant = 0.5
        }
        super.updateConstraints()
    }
    
}
