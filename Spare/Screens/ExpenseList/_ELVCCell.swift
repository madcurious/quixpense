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
        defer {
            super.touchesBegan(touches, with: event)
        }
        
        guard let touchPoint = touches.first?.location(in: self.wrapperView)
            else {
                return
        }
        
        if self.checkTapArea.frame.contains(touchPoint) {
            if self.isChecked == false {
                self.makeSelected(true)
            } else {
                
            }
        } else {
            self.makeHighlighted(true, animated: false)
        }
        
//        if let touchPoint = touches.first?.location(in: self.wrapperView),
//            self.wrapperView.frame.contains(touchPoint) &&
//            self.checkTapArea.frame.contains(touchPoint) == false {
//            self.beginTrackingTouch(at: touchPoint)
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.makeHighlighted(false, animated: false)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            super.touchesEnded(touches, with: event)
        }
        
        guard let touchPoint = touches.first?.location(in: self.wrapperView)
            else {
                return
        }
        
        if self.checkTapArea.frame.contains(touchPoint) {
            self.isChecked = !(self.isChecked)
            self.delegate?.cellDidCheck(self)
        } else {   
            self.makeHighlighted(false, animated: true)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.makeHighlighted(false, animated: false)
        super.touchesCancelled(touches, with: event)
    }
    
//    func beginTrackingTouch(at point: CGPoint) {
//        if self.checkTapArea.frame.contains(point) || self.isChecked {
//            return
//        }
//        self.wrapperView.backgroundColor = UIColor.blue
//    }
//    
//    func endTrackingTouch(at point: CGPoint, animated: Bool) {
//        if self.checkTapArea.frame.contains(point) || self.isChecked {
//            return
//        }
//        
//        if animated {
//            self.wrapperView.backgroundColor = UIColor.blue
//            UIView.animate(withDuration: 0.25,
//                           animations: {
//                            self.wrapperView.backgroundColor = UIColor.white
//            })
//        } else {
//            self.wrapperView.backgroundColor = UIColor.white
//        }
//    }
    
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
    
    func makeSelected(_ selected: Bool) {
        
    }
    
}
