//
//  ExpenseFilter+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 27/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData


extension ExpenseFilter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseFilter> {
        return NSFetchRequest<ExpenseFilter>(entityName: "ExpenseFilter");
    }

    @NSManaged public var fromDate: NSDate?
    @NSManaged public var isUserEditable: Bool
    @NSManaged public var name: String?
    @NSManaged public var rawCategoryIds: NSObject?
    @NSManaged public var rawPaymentMethodIds: NSObject?
    @NSManaged public var rawSubcategoryIds: NSObject?
    @NSManaged public var toDate: NSDate?
    @NSManaged public var displayOrder: Double

}
