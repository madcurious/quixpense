//
//  MonthTagGroup+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 17/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension MonthTagGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MonthTagGroup> {
        return NSFetchRequest<MonthTagGroup>(entityName: "MonthTagGroup")
    }
    
}
