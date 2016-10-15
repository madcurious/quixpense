//
//  PaymentMethodPickerDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 16/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class PaymentMethodPickerDelegate: CustomPickerDelegate {
    
    let allMethods = [PaymentMethod.cash, PaymentMethod.credit, PaymentMethod.debit]
    
    override var dataSource: [Any] {
        return self.allMethods.map({ $0 as Any })
    }
    
    override func textForItemAtIndexPath(_ indexPath: IndexPath) -> String? {
        return self.allMethods[(indexPath as NSIndexPath).row].text
    }
    
}
