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
    @IBOutlet weak var totalLabel: MDAspectFitLabel!
    @IBOutlet weak var dateLabel: MDAspectFitLabel!
    
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
        
        self.backgroundColor = UIColor.lightGrayColor()
    }
    
}
