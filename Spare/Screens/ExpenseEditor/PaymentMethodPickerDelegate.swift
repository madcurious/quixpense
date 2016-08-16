//
//  PaymentMethodPickerDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 16/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class PaymentMethodPickerDelegate: CustomPickerDelegate {
    
    let allMethods = [PaymentMethod.Cash, PaymentMethod.Credit, PaymentMethod.Debit]
    
    override var dataSource: [Any] {
        return self.allMethods.map({ $0 as Any })
    }
    
    override func textForItemAtIndexPath(indexPath: NSIndexPath) -> String? {
        return self.allMethods[indexPath.row].text
    }
    
}