//
//  TestUtil.swift
//  QuixpenseTests
//
//  Created by Matt Quiros on 15/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
@testable import Quixpense
import Bedrock
import XCTest

class TestUtil {
    
    class func makeValidExpense(from rawExpense: RawExpense) -> ValidExpense {
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
