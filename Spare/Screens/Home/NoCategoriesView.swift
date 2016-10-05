//
//  NoCategoriesView.swift
//  Spare
//
//  Created by Matt Quiros on 01/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class NoCategoriesView: UIView {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var error: Error? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            if let error = self.error as? MDErrorType {
                self.messageLabel.text = error.object().message
            } else if let error = self.error as? NSError {
                self.messageLabel.text = error.description
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.labelContainer)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage(named: "noCategoryIcon")?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = Color.UniversalSecondaryTextColor
        
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .byWordWrapping
        self.messageLabel.font = Font.make(.Medium, 18)
        self.messageLabel.textColor = Color.UniversalSecondaryTextColor
        self.messageLabel.textAlignment = .center
    }

}
