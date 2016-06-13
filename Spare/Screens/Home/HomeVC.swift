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
//    var viewHasAppeared = false
    let currentDate = NSDate()
    var isCreatingSummaries = false
    
    lazy var fetcher: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: Summary.entityName)
        request.resultType = .ManagedObjectResultType
        request.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        
//        // It looks like the managed object context should be the root one.
//        // See: http://stackoverflow.com/questions/23231707/ios-7-coredata-fetchedproperty-returns-faulting-array
        let fetcher = NSFetchedResultsController(fetchRequest: request, managedObjectContext: App.state.coreDataStack.privateQueueContext, sectionNameKeyPath: nil, cacheName: nil)
        fetcher.delegate = self
        return fetcher
    }()
    
    var summaries: [Summary]? {
        return self.fetcher.sections?.first?.objects as? [Summary]
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
        
        if let navController = self.navigationController {
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navController.navigationBar.backgroundColor = Color.HomeBackgroundColor
        }
        
        self.collectionView.backgroundColor = Color.HomeBackgroundColor
        self.collectionView.registerCellNib(__HVCCell.nib(), withReuseIdentifier: kViewID)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // The Home tab is not a true stateful view controller--it merely uses the class's
        // loading view so that the cards are properly scrolled to the last item before
        // the UI is shown to the user.
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.ScreenBackgroundColorLightGray
    }
    
    override func buildOperation() -> MDOperation? {
        return
            CreateSummariesOperation(context: App.state.mainQueueContext, baseDate: self.currentDate, summarization: .Day, count: 10, precount: self.numberOfItemsInCollectionView(self.collectionView))
            .onStart({[unowned self] in
                self.isCreatingSummaries = true
                })
            .onReturn({[unowned self] in
                self.isCreatingSummaries = false
                })
        
                .onSuccess({[unowned self] _ in
                    
                    // DEBUG
                    let df = NSDateFormatter()
                    df.timeZone = NSTimeZone.localTimeZone()
                    df.dateStyle = .FullStyle
                    let request = NSFetchRequest(entityName: Summary.entityName)
                    if let summaries = try! App.state.mainQueueContext.executeFetchRequest(request) as? [Summary] {
                        for summary in summaries {
                            print("startDate: \(df.stringFromDate(summary.startDate!)), endDate: \(df.stringFromDate(summary.endDate!))")
                        }
                    }
                    
                    print("++++++")
                    
                    if let summaries = try! App.state.coreDataStack.privateQueueContext.executeFetchRequest(request) as? [Summary] {
                        for summary in summaries {
                            print("startDate: \(df.stringFromDate(summary.startDate!)), endDate: \(df.stringFromDate(summary.endDate!))")
                        }
                    }
                    
                    
                    if self.currentView != .Primary {
                        try! self.fetcher.performFetch()
                        self.collectionView.reloadData()
                        self.collectionView.scrollToLastItem()
                        self.showView(.Primary)
                    }
                    
                })
    }
    
    /*
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
                        if let summary = result as? Summary {
                            print("startDate: \(df.stringFromDate(summary.startDate!))")
                            print("endDate: \(df.stringFromDate(summary.endDate!))")
                            
                            if let categoryTotals = summary.categoryTotals {
                                for (key, value) in categoryTotals {
                                    print("\(key.name!) = \(value)")
                                }
                            }
                            
                            print("+++++++")
                        }
                    }
                    
                    self.collectionView.scrollToLastItem()
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
 */
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // Show the last item first.
//        if self.viewHasAppeared == false {
//            self.viewHasAppeared = true
//        }
//    }
    
}

// MARK: - MDPagedCollectionViewDataSource
extension HomeVC: MDPagedCollectionViewDataSource {
    
    func numberOfItemsInCollectionView(collectionView: MDPagedCollectionView) -> Int {
        guard let summaries = self.summaries
            else {
                return 0
        }
        return summaries.count
    }
    
    func collectionView(collectionView: MDPagedCollectionView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kViewID, forIndex: index) as? __HVCCell
            else {
                fatalError()
        }
        cell.summary = self.summaries?[index]
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
    
    func collectionView(collectionView: MDPagedCollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndex index: Int) {
        if index == 5 && self.isCreatingSummaries == false {
            self.runOperation()
        }
    }
    
}

extension HomeVC: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("\(#function)")
        self.collectionView.reloadData()
        
//        if self.viewHasAppeared == false {
//            self.collectionView.scrollToLastItem()
//            self.showView(.Primary)
//        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        print("\(#function)")
    }
    
    func controller(controller: NSFetchedResultsController, sectionIndexTitleForSectionName sectionName: String) -> String? {
        print("\(#function)")
        return nil
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        print("\(#function)")
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print("\(#function)")
    }
    
}
