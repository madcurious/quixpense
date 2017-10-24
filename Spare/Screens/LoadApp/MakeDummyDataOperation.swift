//
//  MakeDummyDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 22/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Bedrock

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

class MakeDummyDataOperation: BROperation<Bool, Error> {
    
    enum StartDate {
        case date(Date)
        case lastDateSpent
    }
    
    let startDate: MakeDummyDataOperation.StartDate
    
    init(from startDate: MakeDummyDataOperation.StartDate, completionBlock: BROperationCompletionBlock?) {
        self.startDate = startDate
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        let context = Global.coreDataStack.newBackgroundContext()
        let currentDate = Date()
        var start: Date
        
        switch startDate {
        case .date(let date):
            start = date
            
        case .lastDateSpent:
            if let lastDateSpent = getLastDateSpent(from: context),
                let nextDateSpent = Calendar.current.date(byAdding: .day, value: 1, to: lastDateSpent) {
                if Calendar.current.compare(nextDateSpent, to: currentDate, toGranularity: .day) == .orderedAscending {
                    start = nextDateSpent
                } else {
                    // Finish the operation if the nextDateSpent occurs in the future relative to the current date.
                    // Pass false to indicate that no expenses were generated.
                    result = .success(false)
                    return
                }
            } else {
                var startOf2017 = DateComponents()
                startOf2017.month = 1
                startOf2017.day = 1
                startOf2017.year = 2017
                start = Calendar.current.date(from: startOf2017)!
            }
        }
        
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: start, to: currentDate).day!
        var i = 0
        var currentDateSpent = start
        
        repeat {
            let numberOfExpenses = arc4random_uniform(11)
            for _ in 0 ..< numberOfExpenses {
                let amount = 1 + (1000 * Double(arc4random()) / Double(UInt32.max))
                
                let category: CategorySelection = {
                    let randomIndex = Int(arc4random_uniform(UInt32(kCategoryNames.count)))
                    if let randomCategory = kCategoryNames[randomIndex] {
                        return .new(randomCategory)
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
                            if chosenTags.contains(.new(kTagNames[randomIndex])) {
                                continue
                            } else {
                                chosenTags.append(.new(kTagNames[randomIndex]))
                            }
                        }
                        return .list(chosenTags)
                    }
                }()
                
                let rawExpense = RawExpense(amount: "\(amount)",
                    dateSpent: currentDateSpent,
                    categorySelection: category,
                    tagSelection: tags)
                
                let validateOp = ValidateExpenseOperation(rawExpense: rawExpense, context: context, completionBlock: nil)
                validateOp.start()
                switch validateOp.result! {
                case .error(let error):
                    result = .error(error)
                    return
                    
                case .success(let validExpense):
                    let addOp = AddExpenseOperation(context: context,
                                                    validExpense: validExpense,
                                                    completionBlock: nil)
                    addOp.start()
                    switch addOp.result! {
                    case .error(let error):
                        result = .error(error)
                        return
                    default:
                        break
                    }
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
