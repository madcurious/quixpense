//
//  _ELVCCheckboxCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol _ELVCCheckboxCellDelegate {
    
    /// Invoked when the cell is checked or unchecked.
    func cellDidToggleCheck(_ cell: _ELVCCheckboxCell)
    
    /// Invoked when the cell is tapped within its frame but outside the checkbox.
    /// Indicates intent to view the details of the expense.
    func cellDidTap(_ cell: _ELVCCheckboxCell)
    
}

class _ELVCCheckboxCell: UITableViewCell, Themeable {
    
    var expense: Expense? {
        didSet {
            self.amountLabel.text = AmountFormatter.displayText(for: self.expense?.amount)
            self.detailLabel.text = self.expense?.category?.name
            self.setNeedsLayout()
        }
    }
    
    var delegate: _ELVCCheckboxCellDelegate?
    var indexPath: IndexPath?
    
    var isChecked = false {
        didSet {
            self.updateViewsBasedOnCheckedState()
        }
    }
    
    /// Determines whether the cell is tracking touch events for highlighting or checking.
    var isTrackingTouches = false
    
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var checkTapArea: UIView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    var nonHighlightedBackgroundColor = Global.theme.color(for: .mainBackground)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Only way to disable multiple touch on multiple table view cells.
        self.isExclusiveTouch = true
        
        UIView.clearBackgroundColors(self,
                                     self.contentView,
                                     self.checkTapArea)
        self.wrapperView.backgroundColor = Global.theme.color(for: .mainBackground)
        
        self.checkboxImageView.image = UIImage.templateNamed("_ELVCCellCheckboxImageView")
        self.checkmarkImageView.image = UIImage.templateNamed("_ELVCCellCheckmarkImageView")
        
        self.amountLabel.font = Font.regular(17)
        self.amountLabel.textAlignment = .left
        self.amountLabel.numberOfLines = 1
        self.amountLabel.lineBreakMode = .byTruncatingTail
        
        self.detailLabel.font = Font.regular(17)
        self.detailLabel.textAlignment = .right
        self.detailLabel.numberOfLines = 1
        self.detailLabel.lineBreakMode = .byTruncatingTail
        
        self.disclosureIndicatorImageView.image = UIImage.templateNamed("disclosureIndicator")
        self.selectionStyle = .none
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.updateViewsBasedOnCheckedState()
        
        self.amountLabel.textColor = Global.theme.color(for: .elvcCellAmountText)
        self.detailLabel.textColor = Global.theme.color(for: .elvcCellDetailText)
        self.disclosureIndicatorImageView.tintColor = Global.theme.color(for: .disclosureIndicator)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            super.touchesBegan(touches, with: event)
        }
        
        guard let touchPoint = touches.first?.location(in: self.wrapperView)
            else {
                return
        }
        
        self.isTrackingTouches = true
        
        // If the touch is not within the check box, highlight the cell.
        if self.wrapperView.frame.contains(touchPoint) &&
            self.checkTapArea.frame.contains(touchPoint) == false {
            self.makeHighlighted(true, animated: false)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTrackingTouches = false
        self.makeHighlighted(false, animated: false)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTrackingTouches = false
        self.makeHighlighted(false, animated: false)
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            self.isTrackingTouches = false
            super.touchesEnded(touches, with: event)
        }
        
        guard self.isTrackingTouches,
            let touchPoint = touches.first?.location(in: self.wrapperView)
            else {
                return
        }
        
        if self.checkTapArea.frame.contains(touchPoint) {
            self.isChecked = !self.isChecked
            if let delegate = self.delegate {
                delegate.cellDidToggleCheck(self)
            }
        } else {
            self.makeHighlighted(false, animated: true)
        }
    }
    
    func makeHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
//            self.wrapperView.backgroundColor = Global.theme.color(for: .expenseListCellHighlightedBackground)
        } else {
            if animated {
//                self.wrapperView.backgroundColor = Global.theme.color(for: .expenseListCellHighlightedBackground)
                UIView.animate(withDuration: 0.25,
                               animations: {
                                self.wrapperView.backgroundColor = self.nonHighlightedBackgroundColor
                })
            } else {
                self.wrapperView.backgroundColor = self.nonHighlightedBackgroundColor
            }
        }
    }
    
    private func updateViewsBasedOnCheckedState() {
//        self.checkmarkImageView.tintColor = Global.theme.color(for: .elvcCellCheckboxChecked)
        
        if self.isChecked {
//            self.checkboxImageView.tintColor = Global.theme.color(for: .elvcCellCheckboxChecked)
            self.checkmarkImageView.isHidden = false
            
//            self.nonHighlightedBackgroundColor = Global.theme.color(for: .expenseListCellCheckedBackground)
            self.wrapperView.backgroundColor = self.nonHighlightedBackgroundColor
        } else {
//            self.checkboxImageView.tintColor = Global.theme.color(for: .elvcCellCheckboxUnchecked)
            self.checkmarkImageView.isHidden = true
            
            self.nonHighlightedBackgroundColor = Global.theme.color(for: .mainBackground)
            self.wrapperView.backgroundColor = self.nonHighlightedBackgroundColor
        }
    }
    
}
