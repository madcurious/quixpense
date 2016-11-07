//
//  AmountFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

private let kSharedFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
//    formatter.locale = NSLocale(localeIdentifier: NSLocale.availableLocaleIdentifiers()[20])
    formatter.locale = Locale.current
    formatter.alwaysShowsDecimalSeparator = true
    formatter.minimumFractionDigits = 2
    return formatter
}()

final class AmountFormatter {
    
    // Nope, can't initialize it.
    fileprivate init() {}
    
    class func displayText(for amount: NSDecimalNumber?) -> String {
        if let amount = amount,
            let text = kSharedFormatter.string(from: amount) {
            return text
        }
        
        return kSharedFormatter.string(from: 0)!
    }
    
    class func currencyCode() -> String {
        return kSharedFormatter.currencyCode
    }
    
}
