//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

private let kViewID = "kViewID"

private let kLeftRightInset = CGFloat(30)
private let kItemSpacing = CGFloat(10)

class HomeVC: MDStatefulViewController {
    
    var collectionView = MDPagedCollectionView()
    let currentDate = NSDate()
    var isCreatingSummaries = false
    
    var summaries = [Summary]()
    
    override var primaryView: UIView {
        return self.collectionView
    }
    
    override init() {
        super.init()
        self.title = "Home"
        self.tabBarItem.title = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navController = self.navigationController {
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navController.navigationBar.backgroundColor = Color.HomeBackgroundColor
        }
        
        self.collectionView.backgroundColor = Color.HomeBackgroundColor
        self.collectionView.registerCellNib(__HVCCell.nib(), withReuseIdentifier: kViewID)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.ScreenBackgroundColorLightGray
    }
    
    override func buildOperation() -> MDOperation? {
        return
            CreateSummariesOperation(baseDate: self.currentDate, periodization: .Day, count: 10, precount: self.numberOfItemsInCollectionView(self.collectionView))
                .onStart({[unowned self] in
                    self.isCreatingSummaries = true
                    })
                .onReturn({[unowned self] in
                    self.isCreatingSummaries = false
                    })
                
                .onSuccess({[unowned self] result in
                    guard let newSummaries = result as? [Summary]
                        else {
                            return
                    }
                    
                    // DEBUG
                    let df = NSDateFormatter()
                    df.timeZone = NSTimeZone.localTimeZone()
                    df.dateStyle = .FullStyle
                    for summary in newSummaries {
                        print("startDate: \(df.stringFromDate(summary.startDate)), endDate: \(df.stringFromDate(summary.endDate))")
                    }
                    print("++++++")
                    
                    
                    self.summaries.insertContentsOf(newSummaries, at: 0)
                    self.collectionView.reloadData()
                    
                    if self.currentView != .Primary {
                        self.collectionView.scrollToLastItem(animated: false)
                        self.showView(.Primary)
                    }
                    
                    })
    }
    
}

// MARK: - MDPagedCollectionViewDataSource
extension HomeVC: MDPagedCollectionViewDataSource {
    
    func numberOfItemsInCollectionView(collectionView: MDPagedCollectionView) -> Int {
        return self.summaries.count
    }
    
    func collectionView(collectionView: MDPagedCollectionView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kViewID, forIndex: index) as? __HVCCell
            else {
                fatalError()
        }
        cell.summary = self.summaries[index]
        
        return cell
    }
    
}

// MARK: - MDPagedCollectionViewDelegate
extension HomeVC: MDPagedCollectionViewDelegate {
    
    // MARK: Layout
    
    func collectionView(collectionView: MDPagedCollectionView, sizeForItemAtIndex index: Int) -> CGSize {
        var size = collectionView.bounds.size
        size.width = size.width - (kLeftRightInset * 2)
        return size
    }
    
    func insetsForCollectionView(collectionView: MDPagedCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: kLeftRightInset, bottom: 0, right: kLeftRightInset)
    }
    
    func minimumInterItemSpacingForCollectionView(collectionView: MDPagedCollectionView) -> CGFloat {
        return kItemSpacing
    }
    
    // MARK: Events
    
    func collectionView(collectionView: MDPagedCollectionView, didScrollToPage page: CGFloat) {
        if let operation = self.buildOperation()
            where page == 5 && self.isCreatingSummaries == false {
            self.operationQueue.addOperation(operation)
        }
    }
    
}
