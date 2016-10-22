//
//  CategoryPickerAddCategoryCell.swift
//  Spare
//
//  Created by Matt Quiros on 19/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CategoryPickerAddCategoryCell: UITableViewCell {
    
    var categoryName: String? {
        didSet {
            guard let name = self.categoryName
                else {
                    return
            }
            self.textLabel?.text = "New category \"\(name)\""
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
//        self.contentView.backgroundColor = UIColor(hex: 0xeeeeee)
        self.textLabel?.font = Font.make(.Medium, 17)
        self.textLabel?.textColor = UIColor(hex: 0x666666)
    }
    
}
