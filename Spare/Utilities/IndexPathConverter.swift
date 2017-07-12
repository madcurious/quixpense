//
//  IndexPathConverter.swift
//  Spare
//
//  Created by Matt Quiros on 12/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

protocol IndexPathConverter {
    func convert(rawIndexPath: IndexPath) -> IndexPath
}

extension IndexPath {
    
    func convert(for target: IndexPathConverter) -> IndexPath {
        return target.convert(rawIndexPath: self)
    }
    
}
