//
//  HomePageVC.swift
//  Spare
//
//  Created by Matt Quiros on 24/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class HomePageVC: MDOperationViewController {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let customLoadingView = OperationVCLoadingView()
    let zeroView = __HPVCZeroView.instantiateFromNib()
    
    override var loadingView: UIView {
        return self.customLoadingView
    }
    
    override var noResultsView: UIView {
        return self.zeroView
    }
    
    override var primaryView: UIView {
        return self.collectionView
    }
    
    var dateRange: DateRange
    
    init(dateRange: DateRange) {
        self.dateRange = dateRange
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.alwaysBounceVertical = true
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
        
        self.showView(.noResults)
    }
    
    override func makeOperation() -> MDOperation? {
        return nil
    }
    
    
    
}

