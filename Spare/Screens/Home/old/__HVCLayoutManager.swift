//
//  __HVCLayoutManager.swift
//  Spare
//
//  Created by Matt Quiros on 21/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __HVCLayoutManager: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.scrollDirection = .Horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView,
            let attributesForVisibleCells = self.layoutAttributesForElementsInRect(collectionView.bounds)
            else {
                return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
        }
        
        let halfWidth = collectionView.bounds.size.width * 0.5;
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
        
        var candidateAttributes : UICollectionViewLayoutAttributes?
        for attributes in attributesForVisibleCells {
            
            // == Skip comparison with non-cell items (headers and footers) == //
            if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                continue
            }
            
            if let candAttrs = candidateAttributes {
                
                let a = attributes.center.x - proposedContentOffsetCenterX
                let b = candAttrs.center.x - proposedContentOffsetCenterX
                
                if fabsf(Float(a)) < fabsf(Float(b)) {
                    candidateAttributes = attributes;
                }
                
            }
            else { // == First time in the loop == //
                
                candidateAttributes = attributes;
                continue;
            }
            
            
        }
        
        return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
    }
    
}
