//
//  __HPVCDayCell.swift
//  Spare
//
//  Created by Matt Quiros on 25/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

fileprivate let kPadding = CGFloat(10)
fileprivate let kLabelSpacing = CGFloat(6)
fileprivate let kGraphContainerHeight = CGFloat(150)

class __HPVCDayCell: __HPVCSummaryCell {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var graphContainer: UIView!
    
    let graphBackground = __HPVCGraphBackground.instantiateFromNib()
    
    @IBOutlet var paddings: [NSLayoutConstraint]!
    @IBOutlet weak var labelSpacing: NSLayoutConstraint!
    @IBOutlet weak var graphContainerHeight: NSLayoutConstraint!
    
    override var summary: Summary? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            
            self.nameLabel.text = self.summary?.category.name
            self.totalLabel.text = AmountFormatter.displayTextForAmount(self.summary?.total)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.graphContainer.addSubviewAndFill(self.graphBackground)
        self.graphContainer.backgroundColor = UIColor.clear
        
        self.wrapperView.backgroundColor = UIColor(hex: 0x333333)
        
        __HPVCSummaryCell.applyAttributesToNameLabel(self.nameLabel)
        __HPVCSummaryCell.applyAttributesTotalLabel(self.totalLabel)
        
        for padding in self.paddings {
            padding.constant = kPadding
        }
        self.graphContainerHeight.constant = kGraphContainerHeight
        self.labelSpacing.constant = kLabelSpacing
    }
    
    override class func height(for summary: Summary, atCellWidth cellWidth: CGFloat) -> CGFloat {
        let totalLabel = UILabel()
        __HPVCSummaryCell.applyAttributesTotalLabel(totalLabel)
        totalLabel.text = AmountFormatter.displayTextForAmount(summary.total)
        totalLabel.sizeToFit()
        
        let nameLabel = UILabel()
        __HPVCSummaryCell.applyAttributesToNameLabel(nameLabel)
        nameLabel.text = summary.category.name
        let nameLabelWidth = cellWidth - (kPadding * 2 + kLabelSpacing + totalLabel.bounds.size.width)
        let nameLabelHeight = nameLabel.sizeThatFits(CGSize(width: nameLabelWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        let height = kPadding + nameLabelHeight + kPadding + kGraphContainerHeight + kPadding
        return height
    }
    
}
