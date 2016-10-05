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
    
    class func displayTextForAmount(_ amount: NSDecimalNumber?) -> String {
        if let amount = amount,
            let text = kSharedFormatter.string(from: amount) {
            return text
        }
        
        let zeroAmount = NSDecimalNumber(value: 0 as Int)
        return kSharedFormatter.string(from: zeroAmount)!
    }
    
    class func currencyCode() -> String {
        return kSharedFormatter.currencyCode
    }
    
}
