//
//  CustomPickerView.swift
//  Spare
//
//  Created by Matt Quiros on 21/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.dimView.backgroundColor = UIColor.blackColor()
        self.mainContainer.backgroundColor = UIColor.whiteColor()
    }
    
}
