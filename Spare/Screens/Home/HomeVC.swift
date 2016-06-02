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

private let kTopBottomInset = CGFloat(10)
private let kLeftRightInset = CGFloat(30)
private let kItemSpacing = CGFloat(10)

class HomeVC: MDStatefulViewController {
    
    var collectionView = MDPagedCollectionView()
    var viewHasAppeared = false
    
    lazy var fetcher: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: Summary.entityName)
        request.resultType = .ManagedObjectResultType
        request.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        
        // It looks like the managed object context should be the root one.
        // See: http://stackoverflow.com/questions/23231707/ios-7-coredata-fetchedproperty-returns-faulting-array
        let fetcher = NSFetchedResultsController(fetchRequest: request, managedObjectContext: App.state.coreDataStack.privateQueueContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetcher
        
    }()
    
    var topInset: CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        if statusBarHeight > 20 {
            return kTopBottomInset
        }
        return statusBarHeight + kTopBottomInset
    }
    
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
        
        self.edgesForExtendedLayout = .None
        
        self.collectionView.registerCellClass(__HVCCell.self, withReuseIdentifier: kViewID)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // The Home tab is not a true stateful view controller--it merely uses the class's
        // loading view so that the cards are properly scrolled to the last item before
        // the UI is shown to the user.
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.ScreenBackgroundColorLightGray
    }
    
    override func buildOperation() -> MDOperation? {
        let op = MDBlockOperation {[unowned self] in
            try self.fetcher.performFetch()
            return nil
            }
            .onSuccess {[unowned self] (_) in
                self.collectionView.reloadData()
                
                let df = NSDateFormatter()
                df.timeZone = NSTimeZone.localTimeZone()
                df.dateStyle = .FullStyle
                
                // If there are summaries for the display period, scroll to the last item
                // and diplay the primary view.
                if let results = self.fetcher.fetchedObjects
                    where results.isEmpty == false {
                    for result in results {
                        if let summary = result as? Summary,
                            let expenses = summary.valueForKey("expenses") as? [Expense] {
                            print("expenses: \(expenses.count)")
                            print("startDate: \(df.stringFromDate(summary.startDate!))")
                            print("endDate: \(df.stringFromDate(summary.endDate!))")
                            print("+++++++")
                        }
                    }
                    
//                    self.collectionView.scrollToLastItem()
                    self.showView(.Primary)
                }
                    
                    // Otherwise, create the summaries, then re-run the operation.
                else {
                    
                    let currentDate = NSDate()
                    print("currentDate: \(df.stringFromDate(currentDate))")
                    var date: NSDate
                    for i in 0..<5 {
                        date = currentDate.dateByAddingTimeInterval(-(60 * 60 * 24) * Double(i))
                        let summary = Summary(managedObjectContext: App.state.mainQueueContext)
                        summary.startDate = date.firstMoment()
                        summary.endDate = date.lastMoment()
                    }
                    App.state.mainQueueContext.saveContext()
                    self.runOperation()
                }
        }
        return op
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show the last item first.
        if self.viewHasAppeared == false {
            self.viewHasAppeared = true
        }
    }
    
}

extension HomeVC: MDPagedCollectionViewDataSource {
    
    func numberOfItemsInCollectionView(collectionView: MDPagedCollectionView) -> Int {
        guard let objects = self.fetcher.sections?.first?.objects
            else {
                return 0
        }
        let count = objects.count
        return count
    }
    
    func collectionView(collectionView: MDPagedCollectionView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kViewID, forIndex: index) as? __HVCCell
            else {
                fatalError()
        }
        return cell
    }
    
}

extension HomeVC: MDPagedCollectionViewDelegate {
    
    func collectionView(collectionView: MDPagedCollectionView, sizeForItemAtIndex index: Int) -> CGSize {
        var size = collectionView.bounds.size
        size.width = size.width - (kLeftRightInset * 2)
        size.height = size.height - (self.topInset + kTopBottomInset)
        return size
    }
    
    func insetsForCollectionView(collectionView: MDPagedCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.topInset, left: kLeftRightInset, bottom: kTopBottomInset, right: kLeftRightInset)
    }
    
    func minimumInterItemSpacingForCollectionView(collectionView: MDPagedCollectionView) -> CGFloat {
        return kItemSpacing
    }
    
}
