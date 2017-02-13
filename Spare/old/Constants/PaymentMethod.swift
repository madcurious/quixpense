//
//  PaymentMethod.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

enum PaymentMethod: Int {
    
    case cash = 0
    case credit = 1
    case debit = 2
    
    static let allValues = [PaymentMethod.cash, .credit, .debit]
    
    var text: String {
        switch self {
        case .cash:
            return "Cash"
        case .credit:
            return "Credit"
        case .debit:
            return "Debit"
        }
    }
    
    init?(_ int: Int?) {
        switch int {
        case .some(0):
            self = .cash
        case .some(1):
            self = .credit
        case .some(2):
            self = .debit
            
        default:
            return nil
        }
    }
    
}
