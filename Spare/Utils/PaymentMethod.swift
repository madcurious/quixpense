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
    
    init(_ int: Int) {
        switch int {
        case 0:
            self = .Cash
        case 1:
            self = .Credit
        case 2:
            self = .Debit
            
        default:
            fatalError()
        }
    }
    
}