//
//  FilterButton.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class FilterButton: MDButton, Themeable {
    
    @IBOutlet weak var roundedRectView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var filter = Filter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backgroundColor = .red
//        self.filterLabel.backgroundColor = .yellow
//        self.arrowImageView.backgroundColor = .green
        UIView.clearBackgroundColors(self, self.filterLabel, self.arrowImageView)
        
        self.clipsToBounds = true
        
        self.roundedRectView.isUserInteractionEnabled = false
        
        self.filterLabel.font = Global.theme.font(for: .filterButtonText)
        self.filterLabel.numberOfLines = 1
        self.filterLabel.lineBreakMode = .byTruncatingMiddle
        self.filterLabel.text = self.filter.text()
        self.filterLabel.textAlignment = .center
        
        self.arrowImageView.image = UIImage.templateNamed("filterButtonArrow")
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.roundedRectView.backgroundColor = Global.theme.color(for: .filterButtonBackground)
        self.filterLabel.textColor = Global.theme.color(for: .filterButtonContent)
        self.arrowImageView.tintColor = Global.theme.color(for: .filterButtonContent)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: self.frame.origin.x,
                            y: self.frame.origin.y,
                            width: self.roundedRectView.sizeThatFits(CGSize.max).width,
                            height: self.bounds.size.height)
        self.roundedRectView.layer.cornerRadius = self.roundedRectView.bounds.size.height / 2
    }
    
}
