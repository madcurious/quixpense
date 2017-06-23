//
//  TimestampFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

final class TimestampFormatter {
    
    class func year(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(for: date)!
    }
    
}
