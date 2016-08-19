//
//  DatePickerFlowLayout.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class DatePickerFlowLayout: UICollectionViewLayout {
    
    override func collectionViewContentSize() -> CGSize {
        let size = CGSizeMake(
            self.collectionView!.bounds.size.height,
            self.collectionView!.bounds.size.width * CGFloat(self.collectionView!.numberOfSections())
            )
        return size
    }
    
    func indexPathOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        
        
        
        return indexPaths
    }
    
}
