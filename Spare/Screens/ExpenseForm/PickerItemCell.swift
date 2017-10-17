//
//  PickerItemCell.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class PickerItemCell: UITableViewCell {
    
    enum AccessoryImageType {
        case add
        case check
        case remove
        
        var templateImage: UIImage? {
            switch self {
            case .add:
                return UIImage.template(named: "cellAccessoryAdd")
            case .check:
                return UIImage.template(named: "cellAccessoryItemChecked")
            case .remove:
                return UIImage.template(named: "cellAccessoryRemove")
            }
        }
    }
    
    @IBOutlet weak var sizerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stackViewLeading: NSLayoutConstraint!
    @IBOutlet weak var checkImageViewContainerWidth: NSLayoutConstraint!
    
    var separatorLeftInset: CGFloat {
        return self.stackViewLeading.constant + self.checkImageViewContainerWidth.constant + self.stackView.spacing
    }
    
    var accessoryImageType = AccessoryImageType.check {
        didSet {
            self.accessoryImageView.image = self.accessoryImageType.templateImage
            self.applyThemeToAccessoryImageType()
        }
    }
    
    var showsAccessoryImage = false {
        didSet {
            self.accessoryImageView.isHidden = self.showsAccessoryImage == false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.accessoryImageView.image = self.accessoryImageType.templateImage
        self.showsAccessoryImage = false
        
        self.separatorInset = UIEdgeInsetsMake(0, self.separatorLeftInset, 0, 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.showsAccessoryImage = false
        self.nameLabel.text = nil
    }
    
}

extension PickerItemCell: Themeable {
    
    func applyTheme() {
        self.sizerView.clearAllBackgroundColors()
        self.applyThemeToAccessoryImageType()
    }
    
    func applyThemeToAccessoryImageType() {
        switch self.accessoryImageType {
        case .add:
            self.accessoryImageView.tintColor = .black
            self.nameLabel.textColor = .black
        case .check:
            self.accessoryImageView.tintColor = .green
            self.nameLabel.textColor = .black
        case .remove:
            self.accessoryImageView.tintColor = .red
            self.nameLabel.textColor = .red
        }
    }
    
}
