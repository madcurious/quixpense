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
    
    override var isSelected: Bool {
        didSet {
            self.selectionView.fillColor = self.isSelected ? UIColor.black : UIColor.clear
            self.dateLabel.textColor = self.isSelected ? UIColor.white : UIColor.black
            self.selectionView.setNeedsDisplay()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.selectionView.fillColor = self.isHighlighted ? UIColor(hex: 0xcccccc) : UIColor.clear
            self.selectionView.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self, self.contentView, self.dateLabel)
        
        self.dateLabel.textAlignment = .center
        self.dateLabel.textColor = Color.CustomPickerTextColor
        self.dateLabel.font = Font.make(.regular, 16)
        
        self.selectionView.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dateLabel.layer.cornerRadius = self.dateLabel.bounds.size.width / 2
    }
    
}

class __DPVCDayCellSelectionView: UIView {
    
    var fillColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        let insetRect = rect.insetBy(dx: 1, dy: 1)
        let smallerSide = min(insetRect.width, insetRect.height)
        let x = rect.width / 2 - smallerSide / 2
        let y = rect.height / 2 - smallerSide / 2
        let squareRect = CGRect(x: x, y: y, width: smallerSide, height: smallerSide)
        
        let path = UIBezierPath(ovalIn: squareRect)
        self.fillColor.setFill()
        path.fill()
    }
    
}
