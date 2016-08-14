//
//  CustomPickerHeader.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class CustomPickerHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView = UIImageView(image: UIImage.imageFromColor(UIColor.whiteColor()))
        self.label.font = Font.CustomPickerHeaderText
        self.label.textColor = Color.CustomPickerHeaderTextColor
        
    }
    
}

