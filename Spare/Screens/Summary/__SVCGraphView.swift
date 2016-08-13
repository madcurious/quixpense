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
    
    @IBOutlet weak var graphViewContainer: UIView!
    let graphView = GraphView.instantiateFromNib() as GraphView
    
    var summary: Summary? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            self.graphView.segmentedCircle.segments = self.summary?.info
            self.graphView.totalLabel.text = glb_displayTextForTotal(self.summary?.total ?? 0)
            if let summary = self.summary {
                self.graphView.detailLabel.text = DateFormatter.displayTextForSummary(summary)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.graphViewContainer, self.graphView)
        self.graphViewContainer.addSubviewAndFill(self.graphView)
    }
    
}
