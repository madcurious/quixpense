//
//  __ELVCBEmptyCell.swift
//  Spare
//
//  Created by Matt Quiros on 29/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __ELVCBEmptyCell: UITableViewCell {

    let emptyView = __ELVCBEmptyView.instantiateFromNib() as __ELVCBEmptyView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        UIView.clearBackgroundColors(self, self.contentView, self.emptyView)
        self.contentView.addSubviewAndFill(self.emptyView)
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
