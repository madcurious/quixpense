//
//  Filter.swift
//  Quixpense
//
//  Created by Matt Quiros on 26/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation

struct Filter {
    
    enum DisplayMode {
        case expenses
        case categories
        case tags
        
        var title: String {
            switch self {
            case .expenses:
                return "all expenses"
            case .categories:
                return "categories"
            case .tags:
                return "tags"
            }
        }
        
        static let all: [DisplayMode] = [.expenses, .categories, .tags]
    }
    
    var displayMode: DisplayMode
    var period: Period
    
    var title: String {
        return "\(displayMode.title.capitalized), \(period.title)"
    }
    
    static let `default` = Filter(displayMode: .expenses, period: .day)
    
}
