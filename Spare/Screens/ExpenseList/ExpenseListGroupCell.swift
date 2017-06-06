//
//  ExpenseListGroupCell.swift
//  Spare
//
//  Created by Matt Quiros on 06/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseListGroupCell: UICollectionViewCell, Themeable {
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    weak var categoryGroup: CategoryGroup? {
        didSet {
            if let categoryGroup = self.categoryGroup {
                self.groupLabel.text = categoryGroup.category?.name
                self.totalLabel.text = AmountFormatter.displayText(for: categoryGroup.total)
            } else {
                self.arrowImageView.image = nil
                self.groupLabel.text = nil
                self.totalLabel.text = nil
            }
            self.setNeedsLayout()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.applyHighlight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyTheme()
        self.applyHighlight()
    }
    
    func applyTheme() {
        self.groupLabel.font = Global.theme.font(for: .regularText)
        self.totalLabel.font = Global.theme.font(for: .regularText)
        
        self.groupLabel.textColor = Global.theme.color(for: .regularText)
        self.totalLabel.textColor = Global.theme.color(for: .regularText)
    }
    
    func applyHighlight() {
        if self.isHighlighted {
            self.backgroundColor = Global.theme.color(for: .expenseListGroupCellBackgroundHighlighted)
        } else {
            self.backgroundColor = Global.theme.color(for: .expenseListGroupCellBackgroundDefault)
        }
    }
    
}
