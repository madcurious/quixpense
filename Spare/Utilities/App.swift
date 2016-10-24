//
//  App.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

private let kSharedState = App()

private enum SettingKey: String {
    case SelectedPeriodization = "Settings-SelectedPeriodization"
    case SelectedStartOfWeek = "Settings-SelectedStartOfWeek"
}

struct App {
    
//    class var state: App {
//        return kSharedState
//    }
    
//    static var coreDataStack: CoreDataStack! {
//        get {
//            return kSharedState.coreDataStack
//        }
//        set {
//            kSharedState.coreDataStack = newValue
//        }
//    }
//    
//    static var mainQueueContext: NSManagedObjectContext {
//        return kSharedState.coreDataStack.mainQueueContext
//    }
    
    fileprivate init() {}
    
//    fileprivate var coreDataStack: CoreDataStack!
    
    static var coreDataStack: NSPersistentContainer!
    static var mainQueueContext: NSManagedObjectContext {
        return self.coreDataStack.viewContext
    }
    
    static var selectedPeriodization: Periodization {
        get {
            let defaults = UserDefaults.standard
            if let rawValue = defaults.value(forKey: SettingKey.SelectedPeriodization.rawValue) as? Int,
                let periodization = Periodization(rawValue: rawValue) {
                return periodization
            } else {
                defaults.setValue(Periodization.day.rawValue, forKey: SettingKey.SelectedPeriodization.rawValue)
                defaults.synchronize()
                return .day
            }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue.rawValue, forKey: SettingKey.SelectedPeriodization.rawValue)
            defaults.synchronize()
        }
    }
    
    static var selectedStartOfWeek: StartOfWeek {
        get {
            let defaults = UserDefaults.standard
            if let rawValue = defaults.value(forKey: SettingKey.SelectedPeriodization.rawValue) as? Int,
                let startOfWeek = StartOfWeek(rawValue: rawValue) {
                return startOfWeek
            } else {
                defaults.setValue(StartOfWeek.sunday.rawValue, forKey: SettingKey.SelectedStartOfWeek.rawValue)
                defaults.synchronize()
                return .sunday
            }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.setValue(newValue.rawValue, forKey: SettingKey.SelectedStartOfWeek.rawValue)
            defaults.synchronize()
        }
    }
    
    static func allCategories() -> [Category] {
        let request = FetchRequestBuilder<Category>.makeFetchRequest()
        let categories = try! App.mainQueueContext.fetch(request)
        return categories
    }
    
}
