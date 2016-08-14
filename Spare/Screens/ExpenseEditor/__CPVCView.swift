//
//  __CPVCView.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __CPVCView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.dimView.backgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        self.dimView.alpha = 0.7
    }
    
}
