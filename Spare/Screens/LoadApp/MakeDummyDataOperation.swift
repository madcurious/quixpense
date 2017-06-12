//
//  MakeDummyDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 22/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

private let kCategoryNames = [
    "Food and Drinks",
    "Transportation",
    "Grooming",
    "Fitness",
    "Electronics",
    "Vacation"
]

class MakeDummyDataOperation: MDOperation<Any?> {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        self.makeCategories()
        self.makeExpenses()
        
        do {
            try self.context.saveToStore()
        } catch {
            print((error as NSError).userInfo)
            throw error
        }
        
        return nil
    }
    
    func makeCategories() {
        let categoryFetch = NSFetchRequest<Category>(entityName: "Category")
        let categories = try! self.context.fetch(categoryFetch)
        
        // Don't make categories if there already are.
        guard categories.count == 0
            else {
                return
        }

        for categoryName in kCategoryNames {
            let category = Category(context: self.context)
            category.name = categoryName
        }
    }
    
    func makeExpenses() {
        let lastDate: Date = {
            let expenseFetch = NSFetchRequest<Expense>(entityName: "Expense")
            var expenses = try! self.context.fetch(expenseFetch)
            if expenses.count == 0 {
                var components = DateComponents()
                components.month = 1
                components.day = 1
                components.year = 2017
                let fromDate = Calendar.current.date(from: components)!
                return fromDate
            } else {
                expenses.sort(by: { $0.dateSpent!.compare($1.dateSpent! as Date) == .orderedAscending })
                let fromDate = expenses.last!.dateSpent! as Date
                return fromDate
            }
        }()
        
        let toDate = Date()
        
        if lastDate.isSameDayAsDate(toDate) {
            print("From and to date are the same, not making any new expenses.")
            return
        }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: lastDate, to: toDate).day!
        let categoryFetch = NSFetchRequest<Category>(entityName: "Category")
        let categories = try! self.context.fetch(categoryFetch)
        var dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
        
        print("fromDate: \(lastDate)")
        print("toDate: \(toDate)")
        print("Making dummy expenses for \(numberOfDays) days...")
        print("===============")
        
        for i in 0 ..< numberOfDays {
            print("Current date (day \(i + 1)): \(dateSpent)")
            
            var expenses = [Expense]()
            
            for category in categories {
                // Make 0-10 expenses.
                let numberOfExpenses = arc4random_uniform(10)
                print("- Making \(numberOfExpenses) expenses for category '\(category.name!)'")
                
                if numberOfExpenses == 0 {
                    // Avoid making section entities if there will be no expenses to begin with.
                    continue
                }
                
                var categorySectionTotal = 0.0
                
                for _ in 0 ..< numberOfExpenses {
                    let amount = 1 + (2500 * Double(arc4random()) / Double(UInt32.max))
                    categorySectionTotal += amount
                    
                    let newExpense = Expense(context: self.context)
                    newExpense.category = category
                    newExpense.amount = NSDecimalNumber(value: amount)
                    newExpense.dateSpent = dateSpent as NSDate
                    newExpense.dateCreated = Date() as NSDate
                    expenses.append(newExpense)
                    
                    print("-- amount: \(amount)")
                }
                
                self.makeDayCategoryGroup(for: expenses)
                self.makeWeekCategoryGroups(for: expenses)
                expenses = []
            }
            
            dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: dateSpent)!
        }
    }
    
    func makeDayCategoryGroup(for expenses: [Expense]) {
        let category = expenses.first!.category
        let total = expenses.total()
        let startDate = (expenses.first!.dateSpent! as Date).startOfDay()
        let endDate = startDate.endOfDay()
        
        let dayCategoryGroup = DayCategoryGroup(context: self.context)
        dayCategoryGroup.classifier = category
        dayCategoryGroup.total = total
        dayCategoryGroup.startDate = startDate as NSDate
        dayCategoryGroup.endDate = endDate as NSDate
        dayCategoryGroup.sectionIdentifier = SectionDateFormatter.sectionIdentifier(forStartDate: startDate, endDate: endDate)
        
        for expense in expenses {
            expense.dayCategoryGroup = dayCategoryGroup
        }
    }
    
    func makeWeekCategoryGroups(for expenses: [Expense]) {
        let firstWeekdays = [1, 2, 7]
        let entityNames = [md_getClassName(SundayWeekCategoryGroup.self),
                          md_getClassName(MondayWeekCategoryGroup.self),
                          md_getClassName(SaturdayWeekCategoryGroup.self)]
        let groupKeypaths = ["sundayWeekCategoryGroup", "mondayWeekCategoryGroup", "saturdayWeekCategoryGroup"]
        
        for expense in expenses {
            for i in 0 ..< firstWeekdays.count {
                let weekStart = (expense.dateSpent! as Date).startOfWeek(firstWeekday: firstWeekdays[i])
                let weekEnd = weekStart.endOfWeek(firstWeekday: firstWeekdays[i])
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityNames[i])
                fetchRequest.predicate = NSPredicate(format: "%@ == %@ AND %@ == %@ AND %@ == %@",
                                                     argumentArray: [
                                                        "startDate", weekStart,
                                                        "endDate", weekEnd,
                                                        "classifier", expense.category!
                    ])
                if let existingGroup = try! self.context.fetch(fetchRequest).first,
                    let runningTotal = existingGroup.value(forKey: "total") as? NSDecimalNumber {
                    existingGroup.setValue(runningTotal.adding(expense.amount!), forKey: "total")
                    expense.setValue(existingGroup, forKey: entityNames[i].lowercased())
                } else {
                    let newGroup: NSManagedObject = {
                        switch firstWeekdays[i] {
                        case 1:
                            return SundayWeekCategoryGroup(context: self.context)
                        case 2:
                            return MondayWeekCategoryGroup(context: self.context)
                        default:
                            return SaturdayWeekCategoryGroup(context: self.context)
                        }
                    }()
                    newGroup.setValue(weekStart as NSDate, forKey: "startDate")
                    newGroup.setValue(weekEnd as NSDate, forKey: "endDate")
                    newGroup.setValue(expense.amount!, forKey: "total")
                    newGroup.setValue(expense.category!, forKey: "classifier")
                    newGroup.setValue(SectionDateFormatter.sectionIdentifier(forStartDate: weekStart, endDate: weekEnd), forKey: "sectionIdentifier")
                    
                    expense.setValue(newGroup, forKey: groupKeypaths[i])
                }
            }
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
