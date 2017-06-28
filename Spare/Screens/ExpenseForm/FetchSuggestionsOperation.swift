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
            // Find the classifiers whose names contain the query.
            let fetchRequest = T.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", query)
            if var matches = try context.fetch(fetchRequest) as? [T] {
                // Sort the matches by whether the substring occurs earlier in the string.
                matches.sort(by: {
                    let range0 = $0.name!.range(of: query, options: [.caseInsensitive, .diacriticInsensitive])!
                    let range1 = $1.name!.range(of: query, options: [.caseInsensitive, .diacriticInsensitive])!
                    return range0.lowerBound < range1.lowerBound
                })
                suggestions = matches
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
