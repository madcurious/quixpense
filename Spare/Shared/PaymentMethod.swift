//
//  PaymentMethod.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

enum PaymentMethod: Int {
    
    case Cash = 0
    case Credit = 1
    case Debit = 2
    
    var text: String {
        switch self {
        case .Cash:
            return "Cash"
        case .Credit:
            return "Credit"
        case .Debit:
            return "Debit"
        }
    }
    
    init?(_ int: Int?) {
        switch int {
        case .Some(0):
            self = .Cash
        case .Some(1):
            self = .Credit
        case .Some(2):
            self = .Debit
            
        default:
            return nil
        }
    }
    
}