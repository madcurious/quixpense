//
//  TagPickerView.swift
//  Spare
//
//  Created by Matt Quiros on 05/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class TagPickerView: UIView {
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var titleBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleBarSeparatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearAllBackgroundColors()
        self.applyTheme()
        
        self.titleLabel.text = "Tags"
    }
    
}

extension TagPickerView: Themeable {
    
    func applyTheme() {
        self.dimView.backgroundColor = .black
        
        self.titleBarView.backgroundColor = Global.theme.color(for: .mainBackground)
        self.titleBarSeparatorView.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        
        self.titleLabel.font = Global.theme.font(for: .navBarTitle)
        self.titleLabel.textColor = Global.theme.color(for: .barTint)
        self.titleLabel.textAlignment = .center
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.titleLabel.numberOfLines = 1
        
        self.tableView.backgroundColor = .groupTableViewBackground
    }
    
}

extension TagPickerView: SlideUpPickerAnimatable {
    
    var transparentBackgroundView: UIView {
        return self.dimView
    }
    
    var contentView: UIView {
        return self.stackView
    }
    
    var contentViewBottom: NSLayoutConstraint {
        return self.stackViewBottom
    }
    
}
