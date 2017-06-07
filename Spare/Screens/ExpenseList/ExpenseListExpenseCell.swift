//
//  ExpenseListExpenseCell.swift
//  Spare
//
//  Created by Matt Quiros on 07/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseListExpenseCell: UICollectionViewCell, Themeable {
    
    @IBOutlet weak var stemView: UIView!
    @IBOutlet weak var sizerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    weak var expense: Expense? {
        didSet {
            if let expense = self.expense {
                self.descriptionLabel.text = self.makeTagDescription() ?? self.makeDateDescription()
                self.amountLabel.text = AmountFormatter.displayText(for: expense.amount)
            } else {
                self.descriptionLabel.text = nil
                self.amountLabel.text = nil
            }
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sizerView.backgroundColor = .clear
        
        self.applyTheme()
    }
    
    let dateFormatter = DateFormatter()
    
    func applyTheme() {
        self.stemView.backgroundColor = Global.theme.color(for: .expenseListStemView)
        
        self.descriptionLabel.font = Global.theme.font(for: .regularText)
        self.descriptionLabel.textColor = Global.theme.color(for: .regularText)
        self.descriptionLabel.textAlignment = .left
        
        self.amountLabel.font = Global.theme.font(for: .regularText)
        self.amountLabel.textColor = Global.theme.color(for: .regularText)
        self.amountLabel.textAlignment = .right
    }
    
    func makeTagDescription() -> String? {
        guard let tagNames = (self.expense?.tags?.allObjects as? [Tag])?.flatMap({ $0.name }),
            tagNames.isEmpty == false
            else {
                return nil
        }
        return tagNames.joined(separator: ", ")
    }
    
    func makeDateDescription() -> String {
        guard let dateSpent = self.expense?.dateSpent as? Date
            else {
                return ""
        }
        
        switch Global.filter.periodization {
        case .day:
            self.dateFormatter.dateStyle = .none
            self.dateFormatter.timeStyle = .short
            let description = "at \(self.dateFormatter.string(from: dateSpent))"
            return description
            
        case .week, .month:
            self.dateFormatter.dateFormat = "MMM d, h:mm a"
            let description = self.dateFormatter.string(from: dateSpent)
            return description
        }
    }
    
}
