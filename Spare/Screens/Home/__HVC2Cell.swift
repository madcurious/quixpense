//
//  __HVC2Cell.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVC2Cell: UICollectionViewCell {
    
    static let garbageSummaryValue: Summary = {
        let currentDate = NSDate()
        return Summary(startDate: currentDate.firstMoment(), endDate: currentDate.lastMoment(), periodization: .Day)
    }()
    
    let summaryVC = SummaryVC2(summary: __HVCCell.garbageSummaryValue)
    
    var summary: Summary? {
        get {
            return self.summaryVC.summary
        }
        set {
            self.summaryVC.summary = newValue ?? __HVC2Cell.garbageSummaryValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviewAndFill(self.summaryVC.view)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset the scroll position to the start of the card.
        self.summaryVC.collectionView.contentOffset.y = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
