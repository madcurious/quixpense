//
//  GenerateDummy.swift
//  Quixpense
//
//  Created by Matt Quiros on 15/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

class GenerateDummy: BROperation<Bool, Error> {
    
    let context: NSManagedObjectContext
    
    let categories = [
        "Food",
        "Transportation",
        "Groceries",
        "Utilities",
        "Travel",
        "Clothing",
        "Medical",
        Classifier.default
    ]
    
    let tags = [
        "credit",
        "debit",
        "rewards",
        "uber",
        "personal",
        "work"
    ]
    
    init(context: NSManagedObjectContext, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        let startDate: Date = {
            if let lastDateSpent = getLastDateSpent() {
                return lastDateSpent
            }
            var custom = DateComponents()
            custom.month = 9
            custom.day = 1
            custom.year = 2017
            return Calendar.current.date(from: custom)!
        }()
        let endDate = Date()
        
        if BRDateUtil.isSameDay(date1: startDate, date2: endDate, inCalendar: .current) {
            result = .success(false)
            return
        }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        var i = 0
        var currentDateSpent = startDate
        
        repeat {
            let numberOfExpenses = arc4random_uniform(11)
            for _ in 0 ..< numberOfExpenses {
                let amount = 1 + (1000 * Double(arc4random()) / Double(UInt32.max))
                let category = categories[Int(arc4random_uniform(UInt32(categories.count)))]
                let tags: [String] = {
                    let noTags = arc4random_uniform(3) == 1
                    if noTags {
                        return [Classifier.default]
                    } else {
                        let numberOfTags = 1 + Int(arc4random_uniform(UInt32(self.tags.count - 1)))
                        var chosenTags: [String] = []
                        while chosenTags.count != numberOfTags {
                            let randomIndex = Int(arc4random_uniform(UInt32(self.tags.count)))
                            if chosenTags.contains(self.tags[randomIndex]) {
                                continue
                            } else {
                                chosenTags.append(self.tags[randomIndex])
                            }
                        }
                        return chosenTags
                    }
                }()
                
                let validExpense = makeValidExpense(from:
                    RawExpense(amount: "\(amount)",
                        dateSpent: currentDateSpent,
                        category: category,
                        tags: tags))
                print(validExpense)
                let add = WriteExpense(context: context,
                                       validExpense: validExpense,
                                       objectId: nil, completionBlock: nil)
                add.start()
                if case .some(.error(let error)) = add.result {
                    result = .error(error)
                    return
                }
            }
            
            currentDateSpent = Calendar.current.date(byAdding: .day, value: 1, to: currentDateSpent)!
            i += 1
        } while i < numberOfDays
        result = .success(true)
    }
    
}

fileprivate extension GenerateDummy {
    
    func getLastDateSpent() -> Date? {
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
    
    func makeValidExpense(from rawExpense: RawExpense) -> ValidExpense {
        let validateOp = ValidateExpense(rawExpense: rawExpense, completionBlock: nil)
        validateOp.start()
        
        guard let result = validateOp.result
            else {
                fatalError(BRTest.fail(#function, type: .noResult))
        }
        
        switch result {
        case .success(let validExpense):
            return validExpense
        case .error(let error):
            fatalError(BRTest.fail(#function, type: .error(error)))
        }
    }
    
}
