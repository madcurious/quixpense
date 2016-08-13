//
//  StatefulVCRetryView.swift
//  Spare
//
//  Created by Matt Quiros on 01/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class StatefulVCRetryView: MDRetryView {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override var error: ErrorType? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            if let error = self.error as? Error {
                self.messageLabel.text = error.object().message
            } else if let error = self.error as? NSError {
                self.messageLabel.text = error.description
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.clearBackgroundColors(self, self.labelContainer)
        
        self.iconLabel.font = Font.icon(150)
        self.iconLabel.text = Icon.NoCategories.rawValue
        self.iconLabel.textColor = Color.UniversalSecondaryTextColor
        self.iconLabel.textAlignment = .Center
        
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .ByWordWrapping
        self.messageLabel.font = Font.StatefulVCRetryViewMessageLabel
        self.messageLabel.textColor = Color.UniversalSecondaryTextColor
        self.messageLabel.textAlignment = .Center
        
        self.retryButton.setTitle("Retry", forState: .Normal)
    }

}
