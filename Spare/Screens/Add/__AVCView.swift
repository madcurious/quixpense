//
//  __AVCView.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __AVCView: UIView {
    
    @IBOutlet weak var segmentedControlContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tabContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.segmentedControl.setTitle("Expense", forSegmentAtIndex: 0)
        self.segmentedControl.setTitle("Category", forSegmentAtIndex: 1)
    }
    
}