//
//  EnteredExpense.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

struct EnteredExpense {
    var amount: String?
    var date = Date()
    var category = CategorySelection.none
    var tags = TagSelection.none
}
