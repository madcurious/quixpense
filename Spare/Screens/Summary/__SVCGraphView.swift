//
//  __SVCGraphView.swift
//  Spare
//
//  Created by Matt Quiros on 10/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __SVCGraphView: UICollectionReusableView {
    
    @IBOutlet weak var segmentedCircle: __SVCSegmentedCircle!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateStyle = .FullStyle
        return dateFormatter
    }()
    
    var summary: Summary? {
        didSet {
            self.segmentedCircle.summary = self.summary
            self.dateLabel.text = self.summary?.dateRangeDisplayText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.labelContainer, self.totalLabel, self.dateLabel)
        
        self.totalLabel.textAlignment = .Center
        self.totalLabel.font = Font.SummaryCellText
        
        self.dateLabel.textAlignment = .Center
        self.dateLabel.font = Font.SummaryCellText
    }
    
}
