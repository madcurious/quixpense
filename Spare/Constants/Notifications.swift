//
//  Notifications.swift
//  Spare
//
//  Created by Matt Quiros on 05/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

private let prefix = Bundle.main.bundleIdentifier! + "."

class Notifications {
    
    static let CoreDataStackFinishedInitializing = Notification.Name("\(prefix)CoreDataStackFinishedInitializing")
    
    static let MonthPageVCDidSelectDate = Notification.Name("\(prefix)MonthPageVCDidSelectDate")
    
    static let PerformedExpenseOperation = Notification.Name("\(prefix)PerformedExpenseOperation")
    
}
