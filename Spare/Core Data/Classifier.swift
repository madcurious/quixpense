//
//  Classifier.swift
//  Spare
//
//  Created by Matt Quiros on 27/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

protocol Classifier {
    var name: String? { get set }
}

extension Category: Classifier {}

extension Tag: Classifier {}

typealias ClassifierManagedObject = NSManagedObject & Classifier
