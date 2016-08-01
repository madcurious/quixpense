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
    
    case AppUnknownError
    case NoCategoriesYet
    case UserEnteredInvalidValue(String)
    
    func object() -> MDError {
        switch self {
        case .AppUnknownError:
            return MDError("You encountered an error we didn't expect! We just sent a report to our developers and we'll fix this in the next update. :)")
            
        case .NoCategoriesYet:
            return MDError("You have no categories yet! Press and hold the ＋ button to add one.")
            
        case .UserEnteredInvalidValue(let message):
            return MDError(message)
        }
    }
    
}