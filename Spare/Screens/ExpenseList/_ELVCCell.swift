//
//  _ELVCCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol _ELVCCellDelegate {
    
    /// Invoked when the cell is checked or unchecked.
    func cellDidToggleCheck(_ cell: _ELVCCell)
    
    /// Invoked when the cell is tapped within its frame but outside the checkbox.
    /// Indicates intent to view the details of the expense.
    func cellDidTap(_ cell: _ELVCCell)
    
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
            self.updateCheckIcon()
            self.updateCheckIconTint()
        }
    }
    
    /// Determines whether the cell is tracking touch events for highlighting or checking.
    var isTrackingTouches = false
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var checkTapArea: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var disclosureIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Only way to disable multiple touch on multiple table view cells.
        self.isExclusiveTouch = true
        
        UIView.clearBackgroundColors(self,
                                     self.contentView,
                                     self.checkTapArea)
        self.wrapperView.backgroundColor = Global.theme.color(for: .mainBackground)
        
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
        
        self.updateCheckIcon()
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.updateCheckIconTint()
        self.amountLabel.textColor = Global.theme.color(for: .expenseListCellAmountLabel)
        self.detailLabel.textColor = Global.theme.color(for: .expenseListCellDetailLabel)
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
            self.wrapperView.backgroundColor = UIColor.blue
        } else {
            if animated {
                self.wrapperView.backgroundColor = UIColor.blue
                UIView.animate(withDuration: 0.25,
                               animations: {
                                self.wrapperView.backgroundColor = UIColor.white
                })
            } else {
                self.wrapperView.backgroundColor = UIColor.white
            }
        }
    }
    
    private func updateCheckIcon() {
        if self.isChecked {
            self.checkImageView.image = UIImage.templateNamed("_ELVCCellCheckboxChecked")
        } else {
            self.checkImageView.image = UIImage.templateNamed("_ELVCCellCheckboxUnchecked")
        }
    }
    
    private func updateCheckIconTint() {
        if self.isChecked {
            self.checkImageView.tintColor = Global.theme.color(for: .expenseListCellCheckboxChecked)
        } else {
            self.checkImageView.tintColor = Global.theme.color(for: .expenseListCellCheckboxUnchecked)
        }
    }
    
}
