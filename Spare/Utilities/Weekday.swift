//
//  Weekday.swift
//  Spare
//
//  Created by Matt Quiros on 09/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

enum Weekday: Int16 {
    
    case sunday = 1, monday = 2, saturday = 7
    
    func toInt() -> Int {
        return Int(self.rawValue)
    }
    
}
