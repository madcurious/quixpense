//
//  ExpenseListFilterButton.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseListFilterButton: MDButton {
    
    var filter: ExpenseListFilter?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(self.contentView)
        self.backgroundColor = UIColor.red
        self.arrowImageView.backgroundColor = .blue
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 180, height: 22)
    }
    
}
