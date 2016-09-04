//
//  NSNotificationName.swift
//  Spare
//
//  Created by Matt Quiros on 01/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

private let prefix = NSBundle.mainBundle().bundleIdentifier!

enum NSNotificationName {
    
    case MonthPageVCDidSelectDate
    case PerformedExpenseOperation
    
    func string() -> String {
        switch self {
        case .MonthPageVCDidSelectDate:
            return prefix + ".MonthPageVCDidSelectDate"
            
        case .PerformedExpenseOperation:
            return prefix + ".PerformedExpenseOperation"
        }
    }
    
}