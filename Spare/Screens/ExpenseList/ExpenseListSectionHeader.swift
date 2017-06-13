//
//  _ELVCSectionHeader.swift
//  Spare
//
//  Created by Matt Quiros on 07/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

fileprivate let kDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM yyyy"
    return dateFormatter
}()

//fileprivate let kDateStringParser: DateFormatter = {
//    let parser = DateFormatter()
//    parser.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
//    return parser
//}()

class ExpenseListSectionHeader: UICollectionReusableView, Themeable {
    
    @IBOutlet weak var sizerView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var sectionIdentifier: String? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            guard let sectionIdentifier = self.sectionIdentifier
                else {
                    self.leftLabel.text = nil
                    return
            }
            
            let (startDate, endDate) = SectionIdentifier.parse(sectionIdentifier)
            switch Global.filter.periodization {
            case .day:
                self.leftLabel.text = kDateFormatter.string(from: startDate)
                
            case .week:
                let startDateFormatter = DateFormatter()
                startDateFormatter.dateFormat = "d MMM"
                self.leftLabel.text = "\(startDateFormatter.string(from: startDate)) - \(kDateFormatter.string(from: endDate))"
                
            case .month:
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MMM yyyy"
                self.leftLabel.text = "\(monthFormatter.string(from: startDate))"
            }
        }
    }
    
    var sectionTotal: NSDecimalNumber? {
        didSet {
            self.rightLabel.text = AmountFormatter.displayText(for: self.sectionTotal)
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sizerView.backgroundColor = .clear
        
        self.leftLabel.font = Global.theme.font(for: .expenseListSectionHeader)
        self.leftLabel.numberOfLines = 1
        self.leftLabel.textAlignment = .left
        
        self.rightLabel.font = Global.theme.font(for: .expenseListSectionHeader)
        self.rightLabel.numberOfLines = 1
        self.rightLabel.textAlignment = .right
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.backgroundColor = Global.theme.color(for: .expenseListSectionHeaderBackground)
        self.leftLabel.textColor = Global.theme.color(for: .expenseListSectionHeaderText)
        self.rightLabel.textColor = Global.theme.color(for: .expenseListSectionHeaderText)
    }
    
}
