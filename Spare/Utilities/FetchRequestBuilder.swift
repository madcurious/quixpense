//
//  FetchRequestBuilder.swift
//  Spare
//
//  Created by Matt Quiros on 15/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Mold
import CoreData

class FetchRequestBuilder<T: NSFetchRequestResult> {
    
    class func makeFetchRequest() -> NSFetchRequest<T> {
        let request = NSFetchRequest<T>(entityName: md_getClassName(T.self))
        return request
    }
    
}
