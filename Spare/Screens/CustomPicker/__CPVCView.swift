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
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var mainContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self,
            self.tableView
        )
        
        self.dimView.backgroundColor = UIColor.blackColor()
        self.mainContainer.backgroundColor = UIColor.whiteColor()
        
        self.dimView.alpha = 0
        
        self.headerLabel.font = Font.CustomPickerHeaderText
        self.headerLabel.textColor = Color.CustomPickerHeaderTextColor
        
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    override func updateConstraints() {
        self.tableView.layoutIfNeeded()
        
        let maximumHeight = CGFloat(MDScreen.currentScreenIs(.iPhone4S) ? 220 : 300)
        self.tableViewHeight.constant = min(maximumHeight, self.tableView.contentSize.height)
        
        super.updateConstraints()
    }
    
}