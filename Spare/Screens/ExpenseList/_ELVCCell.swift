//
//  _ELVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol _ELVCCellDelegate {
    
    func cellDidCheck(_ cell: _ELVCCell)
    
}

class _ELVCCell: UITableViewCell, Themeable {
    
    var expense: Expense? {
        didSet {
            self.amountLabel.text = AmountFormatter.displayText(for: self.expense?.amount)
            self.detailLabel.text = self.expense?.category?.name
            self.setNeedsLayout()
        }
    }
    
    var delegate: _ELVCCellDelegate?
    var indexPath: IndexPath?
    var isChecked = false {
        didSet {
            if self.isChecked {
                self.checkImageView.image = UIImage.templateNamed("_ELVCCellCheckboxChecked")
                self.checkImageView.tintColor = Global.theme.color(for: .expenseListCellCheckboxChecked)
            } else {
                self.checkImageView.image = UIImage.templateNamed("_ELVCCellCheckboxUnchecked")
                self.checkImageView.tintColor = Global.theme.color(for: .expenseListCellCheckboxUnchecked)
            }
        }
    }
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var checkTapArea: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    private var touchPoint: CGPoint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.wrapperView, self.checkTapArea)
        
        self.amountLabel.font = Font.regular(17)
        self.amountLabel.textAlignment = .left
        self.amountLabel.numberOfLines = 1
        self.amountLabel.lineBreakMode = .byTruncatingTail
        
        self.detailLabel.font = Font.regular(17)
        self.detailLabel.textAlignment = .right
        self.detailLabel.numberOfLines = 1
        self.detailLabel.lineBreakMode = .byTruncatingTail
        
        self.disclosureIndicatorImageView.image = UIImage.templateNamed("disclosureIndicator")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        // Invoke the property observer for isChecked.
        let isChecked = self.isChecked
        self.isChecked = isChecked
        
        self.amountLabel.textColor = Global.theme.color(for: .expenseListCellAmountLabel)
        self.detailLabel.textColor = Global.theme.color(for: .expenseListCellDetailLabel)
        self.disclosureIndicatorImageView.tintColor = Global.theme.color(for: .disclosureIndicator)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPoint = touches.first?.location(in: self)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPoint = touches.first?.location(in: self)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchPoint = self.touchPoint,
            self.checkTapArea.frame.contains(touchPoint) {
            self.isChecked = !(self.isChecked)
            self.delegate?.cellDidCheck(self)
        }
        self.touchPoint = nil
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPoint = nil
        super.touchesCancelled(touches, with: event)
    }
    
}
