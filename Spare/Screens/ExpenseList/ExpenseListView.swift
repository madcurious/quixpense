//
//  ExpenseListView.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseListView: UIView {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var noExpensesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Global.theme.color(for: .mainBackground)
        
        self.activityIndicatorView.startAnimating()
        
        self.noExpensesLabel.textAlignment = .center
        self.noExpensesLabel.numberOfLines = 0
        self.noExpensesLabel.lineBreakMode = .byWordWrapping
        self.noExpensesLabel.isHidden = true
        self.noExpensesLabel.attributedText = NSAttributedString(attributedStrings:
            NSAttributedString(string: "No expenses found",
                               font: Global.theme.font(for: .infoLabelMainText),
                               textColor: Global.theme.color(for: .promptLabel)),
                                                                 NSAttributedString(string: "\n\nYou must go out and spend your\nmoney.",
                                                                                    font: Global.theme.font(for: .infoLabelSecondaryText),
                                                                                    textColor: Global.theme.color(for: .promptLabel))
        )
        
        self.collectionView.isHidden = true
        
    }
    
}
