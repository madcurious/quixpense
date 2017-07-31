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

class MakeDummyDataOperation: TBOperation<Bool, Error> {
    
    override func main() {
        let context = Global.coreDataStack.newBackgroundContext()
        
        let lastDateSpent = getLastDateSpent(from: context)
        let currentDate = Date()
        
        // Don't generate expenses if the last date spent is the same day as the current date.
        // Result should be success but pass false to signify that no expenses were generated.
        if let lastDateSpent = lastDateSpent,
            lastDateSpent.isSameDayAsDate(currentDate) {
            result = .success(false)
            return
        }
        
        let startDate: Date = {
            if let lastDateSpent = lastDateSpent {
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
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day!
        var i = 0
        var currentDateSpent = startDate
        
        repeat {
            let numberOfExpenses = arc4random_uniform(11)
            for _ in 0 ..< numberOfExpenses {
                let amount = 1 + (1000 * Double(arc4random()) / Double(UInt32.max))
                
                let category: CategorySelection = {
                    let randomIndex = Int(arc4random_uniform(UInt32(kCategoryNames.count)))
                    if let randomCategory = kCategoryNames[randomIndex] {
                        return .name(randomCategory)
                    }
                    return .none
                }()
                
                let tags: TagSelection = {
                    let noTags = arc4random_uniform(2) == 1
                    if noTags {
                        return .none
                    } else {
                        let numberOfTags = Int(arc4random_uniform(UInt32(kTagNames.count)))
                        if numberOfTags == 0 {
                            return .none
                        }
                        var chosenTags: [TagSelection.Member] = []
                        while chosenTags.count != numberOfTags {
                            let randomIndex = Int(arc4random_uniform(UInt32(kTagNames.count)))
                            if chosenTags.contains(.name(kTagNames[randomIndex])) {
                                continue
                            } else {
                                chosenTags.append(.name(kTagNames[randomIndex]))
                            }
                        }
                        return .list(chosenTags)
                    }
                }()
                
                let addOp = AddExpenseOperation(context: context,
                                                amount: NSDecimalNumber(value: amount),
                                                dateSpent: currentDateSpent,
                                                category: category,
                                                tags: tags,
                                                completionBlock: nil)
                addOp.start()
                
                switch addOp.result {
                case .error(let error):
                    result = .error(error)
                    return
                    
                default:
                    break
                }
            }
            
            currentDateSpent = Calendar.current.date(byAdding: .day, value: 1, to: currentDateSpent)!
            i += 1
        } while i < numberOfDays
        
        do {
            try context.saveToStore()
            result = .success(true)
        } catch {
            print((error as NSError).userInfo)
            result = .error(error)
        }
    }
    
    func getLastDateSpent(from context: NSManagedObjectContext) -> Date? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Expense.dateSpent), ascending: false)
        ]
        if let fetchedObjects = try? context.fetch(fetchRequest),
            fetchedObjects.count > 0,
            let lastExpense = fetchedObjects.first {
            return lastExpense.dateSpent as Date?
        }
        return nil
    }
    
}
