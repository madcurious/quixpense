//
//  _EFPFilterCell.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class _EFPFilterCell: UITableViewCell, Themeable {
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButtonTapArea: UIView!
    @IBOutlet weak var editButton: MDImageButton!
    
    @IBOutlet weak var nameLabelLeading: NSLayoutConstraint!
    
    var filter: ExpenseFilter? {
        didSet {
            self.nameLabel.text = self.filter?.name
            self.editButtonTapArea.isHidden = self.filter?.isUserEditable == false
            self.setNeedsLayout()
        }
    }
    
    var isChecked = false {
        didSet {
            self.checkmarkImageView.isHidden = self.isChecked == false
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkmarkImageView.image = UIImage.templateNamed("cellAccessoryCheckmark")
        self.checkmarkImageView.isHidden = true
        
        self.nameLabel.font = Font.regular(17)
        self.nameLabel.numberOfLines = 1
        self.nameLabel.lineBreakMode = .byTruncatingTail
        
        self.editButtonTapArea.backgroundColor = UIColor.clear
        
        self.editButton.image = UIImage.templateNamed("cellAccessoryEdit")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.checkmarkImageView.tintColor = Global.theme.color(for: .cellAccessoryIcon)
        self.nameLabel.textColor = Global.theme.color(for: .cellMainText)
        self.editButton.tintColor = Global.theme.color(for: .cellAccessoryIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsets(top: 0, left: self.nameLabelLeading.constant, bottom: 0, right: 0)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.editButtonTapArea.frame.contains(point) {
            return self.editButton
        }
        return super.hitTest(point, with: event)
    }
    
}
