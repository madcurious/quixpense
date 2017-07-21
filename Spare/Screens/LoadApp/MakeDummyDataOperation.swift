//
//  MakeDummyDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 22/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

private let kCategoryNames: [String?] = [
    "Food and Drinks",
    "Transportation",
    "Grooming",
    "Fitness",
    "Electronics",
    "Vacation",
    nil
]

private let kTagNames = [
    "Rideshare",
    "Cash",
    "Credit",
    "Personal",
    "Work"
]

class MakeDummyDataOperation: MDOperation<Any?> {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        let startDate: Date = try {
            if let lastDateSpent = try self.getLastExpenseDateSpent() {
                let nextDateSpent = Calendar.current.date(byAdding: .day, value: 1, to: lastDateSpent)!
                return nextDateSpent
            } else {
                var components = DateComponents()
                components.month = 1
                components.day = 1
                components.year = 2017
                let startDate = Calendar.current.date(from: components)!
                return startDate
            }
        }()
        
        let currentDate = Date()
        
        // Don't make any new expenses if it's not a new day.
        if startDate.isSameDayAsDate(currentDate) {
            return nil
        }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day!
        var i = 0
        var currentDateSpent = startDate
        
        repeat {
            let numberOfExpenses = arc4random_uniform(11)
            for _ in 0 ..< numberOfExpenses {
                let amount = 1 + (1000 * Double(arc4random()) / Double(UInt32.max))
                
                let category: CategoryInput = {
                    let randomIndex = Int(arc4random_uniform(UInt32(kCategoryNames.count)))
                    if let randomCategory = kCategoryNames[randomIndex] {
                        return .name(randomCategory)
                    }
                    return .none
                }()
                
                let tags: Set<TagInput>? = {
                    let noTags = arc4random_uniform(2) == 1
                    if noTags {
                        return nil
                    } else {
                        let numberOfTags = Int(arc4random_uniform(UInt32(kTagNames.count)))
                        if numberOfTags == 0 {
                            return nil
                        }
                        var chosenTags = Set<TagInput>()
                        while chosenTags.count != numberOfTags {
                            let randomIndex = Int(arc4random_uniform(UInt32(kTagNames.count)))
                            if chosenTags.contains(.name(kTagNames[randomIndex])) {
                                continue
                            } else {
                                chosenTags.insert(.name(kTagNames[randomIndex]))
                            }
                        }
                        return chosenTags
                    }
                }()
                
                let addOp = AddExpenseOperation(context: self.context,
                                                amount: NSDecimalNumber(value: amount),
                                                dateSpent: currentDateSpent,
                                                category: category,
                                                tags: tags,
                                                completionBlock: nil)
                addOp.start()
                
                switch addOp.result {
                case .error(let error):
                    throw error
                default: break
                }
            }
            
            currentDateSpent = Calendar.current.date(byAdding: .day, value: 1, to: currentDateSpent)!
            i += 1
        } while i < numberOfDays
        
        do {
            try self.context.saveToStore()
        } catch {
            print((error as NSError).userInfo)
            throw error
        }
        
        return nil
    }
    
    func getLastExpenseDateSpent() throws -> Date? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Expense.dateSpent), ascending: false)
        ]
        if let lastExpense = try self.context.fetch(fetchRequest).first {
            return lastExpense.dateSpent as Date?
        }
        return nil
    }
    
}
