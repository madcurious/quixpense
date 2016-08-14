//
//  __CPVCView.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __CPVCView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.dimView.backgroundColor = UIColor.blackColor()
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        self.dimView.alpha = 0.7
        
        self.tableView.separatorStyle = .None
    }
    
    override func updateConstraints() {
        self.tableView.layoutIfNeeded()
        self.tableViewHeight.constant = min(300, self.tableView.contentSize.height)
        super.updateConstraints()
    }
    
}