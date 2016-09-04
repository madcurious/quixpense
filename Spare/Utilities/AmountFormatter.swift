//
//  AmountFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

private let kSharedFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    return formatter
}()

final class AmountFormatter {
    
    // Nope, can't initialize it.
    private init() {}
    
    class func displayTextForAmount(amount: NSDecimalNumber) -> String {
        if let text = kSharedFormatter.stringFromNumber(amount) {
            return text
        }
        
        let zeroAmount = NSDecimalNumber(integer: 0)
        return kSharedFormatter.stringFromNumber(zeroAmount)!
    }
    
}