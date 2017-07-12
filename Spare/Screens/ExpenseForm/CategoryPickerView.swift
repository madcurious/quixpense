//
//  CategoryPickerView.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class CategoryPickerView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBarView: UIView!
    @IBOutlet weak var titleBarSeparatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.titleLabel.text = "Select a category"
    }
    
}

extension CategoryPickerView: Themeable {
    
    func applyTheme() {
        self.clearAllBackgroundColors()
        
        self.dimView.backgroundColor = .black
        
        self.titleBarView.backgroundColor = Global.theme.color(for: .mainBackground)
        self.titleBarSeparatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        
        self.titleLabel.font = Global.theme.font(for: .navBarTitle)
        self.titleLabel.textColor = Global.theme.color(for: .barTint)
        self.titleLabel.textAlignment = .center
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.titleLabel.numberOfLines = 1
        
        self.tableView.backgroundColor = Global.theme.color(for: .mainBackground)
    }
    
}
