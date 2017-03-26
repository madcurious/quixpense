//
//  PaymentMethod+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData


extension PaymentMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentMethod> {
        return NSFetchRequest<PaymentMethod>(entityName: "PaymentMethod");
    }

    @NSManaged public var name: String?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension PaymentMethod {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}
