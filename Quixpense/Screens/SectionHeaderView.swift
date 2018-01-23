//
//  SectionHeaderView.swift
//  Quixpense
//
//  Created by Matt Quiros on 23/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock

class SectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var sectionIdentifier: String? {
        didSet {
            updateSectionIdentifier()
        }
    }
    
    var total: NSDecimalNumber? {
        didSet {
            updateTotal()
        }
    }
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    fileprivate let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupStructure()
        applyTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStructure()
        applyTheme()
    }
    
    func setupStructure() {
        let viewFromNib = viewFromOwnedNib()
        viewFromNib.performRecursively { $0.backgroundColor = .clear }
        addSubviewsAndFill(viewFromNib)
    }
    
    func applyTheme() {
        containerView.backgroundColor = Palette.gray_666666
        leftLabel.textColor = Palette.white
        rightLabel.textColor = Palette.white
    }
    
}

fileprivate extension SectionHeaderView {
    
    func updateSectionIdentifier() {
        guard let tokens = sectionIdentifier?.components(separatedBy: "-"),
            let startTimeInterval = TimeInterval(tokens[0]),
            let endTimeInterval = TimeInterval(tokens[1])
            else {
                leftLabel.text = nil
                return
        }
        
        let startDate = Date(timeIntervalSince1970: startTimeInterval)
        let endDate = Date(timeIntervalSince1970: endTimeInterval)
        leftLabel.text = {
            if BRDateUtil.isSameDay(date1: startDate, date2: endDate, inCalendar: .current) {
                return dateFormatter.string(from: startDate)
            }
            let startString = dateFormatter.string(from: startDate)
            let endString = dateFormatter.string(from: endDate)
            return "\(startString) to \(endString)"
        }()
    }
    
    func updateTotal() {
        rightLabel.text = {
            if let total = total {
                return numberFormatter.string(from: total)
            }
            return nil
        }()
    }
    
}
