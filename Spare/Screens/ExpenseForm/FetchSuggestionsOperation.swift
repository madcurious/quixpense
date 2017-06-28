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

class FetchSuggestionsOperation: MDOperation<[NSManagedObject]> {
    
    var query: String?
    var classifierType: ClassifierType
    
    init(query: String?, classifierType: ClassifierType) {
        self.query = query
        self.classifierType = classifierType
    }
    
    override func makeResult(from source: Any?) throws -> [NSManagedObject] {
        let context = Global.coreDataStack.viewContext
        var suggestions = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.classifierType.entityName())
        
        if let query = self.query {
            // Find the classifiers whose names contain the query.
            fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", query)
            if var matches = try context.fetch(fetchRequest) as? [NSManagedObject] {
                // Sort the matches by whether the substring occurs earlier in the string.
                matches.sort(by: {
                    let name0 = $0.value(forKey: "name") as! String
                    let range0 = name0.range(of: query, options: [.caseInsensitive, .diacriticInsensitive])!
                    
                    let name1 = $1.value(forKey: "name") as! String
                    let range1 = name1.range(of: query, options: [.caseInsensitive, .diacriticInsensitive])!
                    return range0.lowerBound < range1.lowerBound
                })
                suggestions = matches
            }
        } else {
            if let allItems = try context.fetch(fetchRequest) as? [NSManagedObject] {
                suggestions = allItems
            }
        }
        
        return suggestions
    }
    
}
