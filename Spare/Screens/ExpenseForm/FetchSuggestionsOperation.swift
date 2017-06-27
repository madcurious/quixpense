//
//  FetchSuggestionsOperation.swift
//  Spare
//
//  Created by Matt Quiros on 27/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

class FetchSuggestionsOperation<T: ClassifierManagedObject>: MDOperation<[T]> {
    
    var query: String?
    
    init(query: String?) {
        self.query = query
    }
    
    override func makeResult(from source: Any?) throws -> [T] {
        let context = Global.coreDataStack.viewContext
        var suggestions = [T]()
        
        if let query = self.query {
            // First, find the classifiers whose names match exactly with the query.
            let equalsRequest = T.fetchRequest()
            equalsRequest.predicate = NSPredicate(format: "name ==[c] %@", query)
            if let matches = try context.fetch(equalsRequest) as? [T] {
                suggestions.append(contentsOf: matches)
            }
            
            if self.isCancelled {
                return []
            }
            
            // Next, find the classifiers whose names contain the query.
            let containsRequest = T.fetchRequest()
            containsRequest.predicate = NSPredicate(format: "name contains[c] %@", query)
            if let matches = try context.fetch(containsRequest) as? [T] {
                matches.forEach({
                    if Set<T>(suggestions).contains($0) == false {
                        suggestions.append($0)
                    }
                })
            }
        } else {
            let allRequest = T.fetchRequest()
            if let allItems = try context.fetch(allRequest) as? [T] {
                suggestions = allItems
            }
        }
        
        return suggestions
    }
    
}
