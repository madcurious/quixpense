//
//  ExpenseFormViewDeleteView.swift
//  Spare
//
//  Created by Matt Quiros on 25/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class ExpenseFormViewDeleteView: UIView {
    
    @IBOutlet var separatorViews: [UIView]!
    @IBOutlet weak var deleteButton: BRButton!
    @IBOutlet weak var deleteButtonLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let ownedView = ownedViewFromNib()
        addSubviewsAndFill(ownedView)
        clearAllBackgroundColors()
        backgroundColor = Global.theme.color(for: .mainBackground)
        
        deleteButtonLabel.font = Global.theme.font(for: .regularText)
        deleteButtonLabel.textColor = .red
        deleteButtonLabel.textAlignment = .center
        deleteButtonLabel.text = "Delete expense"
        
        separatorViews.forEach {
            $0.backgroundColor = Global.theme.color(for: .tableViewSeparator)
        }
    }
    
}
