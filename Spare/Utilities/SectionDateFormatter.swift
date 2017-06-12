//
//  SectionDateFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 12/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

final class SectionDateFormatter {
    
    fileprivate init() {}
    
    class func sectionIdentifier(forStartDate startDate: Date, endDate: Date) -> String {
        return "\(startDate.timeIntervalSince1970)-\(endDate.timeIntervalSince1970)"
    }
    
    class func parseDates(from sectionIdentifier: String) -> (startDate: Date, endDate: Date) {
        let tokens = sectionIdentifier.components(separatedBy: "-")
        let startDate = Date(timeIntervalSince1970: TimeInterval(tokens[0])!)
        let endDate = Date(timeIntervalSince1970: TimeInterval(tokens[1])!)
        return (startDate, endDate)
    }
    
}
