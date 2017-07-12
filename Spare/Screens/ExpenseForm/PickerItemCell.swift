//
//  PickerItemCell.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class PickerItemCell: UITableViewCell {
    
    @IBOutlet weak var sizerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stackViewLeading: NSLayoutConstraint!
    @IBOutlet weak var checkImageViewContainerWidth: NSLayoutConstraint!
    
    private static let stackViewLeading = CGFloat(10)
    private static let stackViewSpacing = CGFloat(6)
    private static let checkImageViewContainerWidth = CGFloat(22)
    
    var separatorLeftInset: CGFloat {
        return self.stackViewLeading.constant + self.checkImageViewContainerWidth.constant + self.stackView.spacing
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.checkImageView.image = UIImage.templateNamed("cellAccessoryItemChecked")
        self.checkImageView.isHidden = true
        
        self.separatorInset = UIEdgeInsetsMake(0, self.separatorLeftInset, 0, 0)
//        self.stackViewLeading.constant = PickerItemCell.stackViewLeading
//        self.stackView.spacing = PickerItemCell.stackViewSpacing
//        self.checkImageViewContainerWidth.constant = PickerItemCell.checkImageViewContainerWidth
    }
    
    var isActive = false {
        didSet {
            self.checkImageView.isHidden = self.isActive == false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isActive = false
        self.nameLabel.text = nil
    }
    
}

extension PickerItemCell: Themeable {
    
    func applyTheme() {
        self.sizerView.clearAllBackgroundColors()
        self.checkImageView.tintColor = Global.theme.color(for: .checkImageView)
    }
    
}
