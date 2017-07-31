//
//  Global.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

struct Global {
    
//    static var coreDataStack: CoreDataStack!
    static var coreDataStack: NSPersistentContainer!
    static var theme = LightTheme()
    static var filter = Filter()
    static var startOfWeek = StartOfWeek(rawValue: Locale.current.calendar.firstWeekday)!
    
}
