//
//  FetchRequest.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

struct FetchRequest<T: NSFetchRequestResult> {
    
    static func make() -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: md_getClassName(T.self))
        return fetchRequest
    }
    
}
