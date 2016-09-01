//
//  __DPVCDayCell.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __DPVCDayCell: UICollectionViewCell {
    
    @IBOutlet weak var selectionView: __DPVCDayCellSelectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override var selected: Bool {
        didSet {
            self.selectionView.fillColor = self.selected ? UIColor.blackColor() : UIColor.clearColor()
            self.dateLabel.textColor = self.selected ? UIColor.whiteColor() : UIColor.blackColor()
            self.selectionView.setNeedsDisplay()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.selectionView.fillColor = self.highlighted ? UIColor(hex: 0xcccccc) : UIColor.clearColor()
            self.selectionView.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.contentView, self.dateLabel)
        
        self.dateLabel.textAlignment = .Center
        self.dateLabel.textColor = Color.CustomPickerTextColor
        self.dateLabel.font = Font.make(.Medium, 16)
        
        self.selectionView.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dateLabel.layer.cornerRadius = self.dateLabel.bounds.size.width / 2
    }
    
}

class __DPVCDayCellSelectionView: UIView {
    
    var fillColor = UIColor.clearColor()
    
    override func drawRect(rect: CGRect) {
        let insetRect = CGRectInset(rect, 1, 1)
        let smallerSide = min(insetRect.width, insetRect.height)
        let x = rect.width / 2 - smallerSide / 2
        let y = rect.height / 2 - smallerSide / 2
        let squareRect = CGRectMake(x, y, smallerSide, smallerSide)
        
        let path = UIBezierPath(ovalInRect: squareRect)
        self.fillColor.setFill()
        path.fill()
    }
    
}