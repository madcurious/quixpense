//
//  ClassifierGroupManagedObject.swift
//  Spare
//
//  Created by Matt Quiros on 16/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

protocol ClassifierGroupManagedObject {
    
    var total: NSDecimalNumber? { get set }
    
    func addToExpenses(_ value: Expense)
    func removeFromExpenses(_ value: Expense)
    
}
