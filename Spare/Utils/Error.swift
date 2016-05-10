//
//  Error.swift
//  Spare
//
//  Created by Matt Quiros on 10/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

enum Error: MDErrorType {
    
    case UserEnteredInvalidValue(String)
    
    func object() -> MDError {
        switch self {
        case .UserEnteredInvalidValue(let message):
            return MDError(message)
        }
    }
    
}