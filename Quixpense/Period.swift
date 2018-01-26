//
//  Period.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation

enum Period {
    
    case day, week, month
    
    static let all: [Period] = [.day, .week, .month]
    
    var title: String {
        switch self {
        case .day:
            return "daily"
        case .week:
            return "weekly"
        case .month:
            return "monthly"
        }
    }
    
}
