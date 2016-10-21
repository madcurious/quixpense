//
//  SearchCategoryOperation.swift
//  Spare
//
//  Created by Matt Quiros on 21/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Mold

class SearchCategoryOperation: MDOperation {
    
    var searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        let request = FetchRequestBuilder<Category>.makeFetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", self.searchText)
        
        if self.isCancelled {
            return nil
        }
        
        return try App.mainQueueContext.fetch(request)
    }
    
}
