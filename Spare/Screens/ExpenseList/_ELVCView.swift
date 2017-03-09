//
//  _ELVCView.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _ELVCView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Global.theme.color(for: .mainBackground)
        self.tableView.separatorStyle = .none
    }
    
}
