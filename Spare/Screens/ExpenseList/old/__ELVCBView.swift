//
//  __ELVCBView.swift
//  Spare
//
//  Created by Matt Quiros on 29/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __ELVCBView: UIView {
    
    @IBOutlet weak var colorExtender: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var colorExtenderHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Color.UniversalBackgroundColor
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor  = Color.SeparatorColor
    }
    
}
