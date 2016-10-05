//
//  NSNotificationName.swift
//  Spare
//
//  Created by Matt Quiros on 01/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

private let prefix = Bundle.main.bundleIdentifier!

enum NSNotificationName {
    
    case monthPageVCDidSelectDate
    case performedExpenseOperation
    
    func string() -> String {
        switch self {
        case .monthPageVCDidSelectDate:
            return prefix + ".MonthPageVCDidSelectDate"
            
        case .performedExpenseOperation:
            return prefix + ".PerformedExpenseOperation"
        }
    }
    
}
