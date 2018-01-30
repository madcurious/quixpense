//
//  AmountFormatter.swift
//  Quixpense
//
//  Created by Matt Quiros on 30/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation

final class AmountFormatter {
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    class func string(from amount: NSDecimalNumber) -> String? {
        return formatter.string(from: amount)
    }
    
}
