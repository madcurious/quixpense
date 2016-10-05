//
//  GraphView.swift
//  Spare
//
//  Created by Matt Quiros on 28/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class GraphView: UIView {
    
    @IBOutlet weak var segmentedCircle: SegmentedCircle!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self.segmentedCircle, self.labelContainer)
        
        self.totalLabel.textColor = Color.UniversalTextColor
        self.totalLabel.font = Font.make(.Medium, 32)
        self.totalLabel.adjustsFontSizeToFitWidth = true
        self.totalLabel.numberOfLines = 1
        self.totalLabel.lineBreakMode = .byClipping
        self.totalLabel.textAlignment = .center
        
        self.detailLabel.textColor = Color.UniversalTextColor
        self.detailLabel.font = Font.make(.Medium, 18)
        self.detailLabel.numberOfLines = 0
        self.detailLabel.lineBreakMode = .byWordWrapping
        self.detailLabel.textAlignment = .center
        
    }
    
}
