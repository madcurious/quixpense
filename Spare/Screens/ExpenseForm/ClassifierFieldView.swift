//
//  ClassifierFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 26/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class ClassifierFieldView: UIView, Themeable {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var editButton: BRButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var clearButton: BRButton!
    @IBOutlet weak var clearButtonImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let internalView = self.ownedViewFromNib(nibName: String(describing: ClassifierFieldView.self))
        addSubviewsAndFill(internalView)
        
        clearAllBackgroundColors()
        applyTheme()
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        clearButtonImageView.image = UIImage.template(named: "cellAccessoryClear")
    }
    
    func applyTheme() {
        iconImageView.tintColor = Global.theme.color(for: .fieldIcon)
        nameLabel.font = Global.theme.font(for: .regularText)
        clearButtonImageView.tintColor = Global.theme.color(for: .cellAccessoryClear)
    }
    
}
