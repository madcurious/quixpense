//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
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
    
    var customView = __HVCView.instantiateFromNib() as __HVCView
    var viewHasAppeared = false
    
    lazy var fetcher: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: Summary.entityName)
        request.resultType = .ManagedObjectResultType
//        request.propertiesToFetch = [
//            "startDate", "endDate"
//            {
//                let totalColumn = NSExpressionDescription()
//                totalColumn.name = "total"
//                totalColumn.expression = NSExpression(format: "@sum.expenses")
//                totalColumn.expressionResultType = .DecimalAttributeType
//                return totalColumn
//            }()
//        ]
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
        return self.customView
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
        
        let collectionView = self.customView.collectionView
        collectionView.registerClass(__HVCCell.self, forCellWithReuseIdentifier: kViewID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = __HVCLayoutManager()
        
        // The Home tab is not a true stateful view controller--it merely uses the class's
        // loading view so that the cards are properly scrolled to the last item before
        // the UI is shown to the user.
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.Gray100
    }
    
    override func buildOperation() -> MDOperation? {
        let op = MDBlockOperation {[unowned self] in
            try self.fetcher.performFetch()
            return nil
            }
            .onSuccess {[unowned self] (_) in
                let collectionView = self.customView.collectionView
                collectionView.reloadData()
                
                if let results = self.fetcher.fetchedObjects
                    where results.isEmpty == false {
                    for result in results {
                        if let summary = result as? Summary,
                            let expenses = summary.valueForKey("expenses") as? [Expense] {
                            print("expenses: \(expenses.count)")
                            print("+++++++")
                        }
                    }
                    
                    let lastItem = collectionView.numberOfItemsInSection(0) - 1
                    collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: lastItem, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
                    collectionView.collectionViewLayout.invalidateLayout()
                    
                    self.showView(.Primary)
                } else {
                    
                    let currentDate = NSDate()
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

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = self.fetcher.sections,
            let objects = sections[section].objects
            else {
                return 0
        }
        let count = objects.count
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kViewID, forIndexPath: indexPath) as? __HVCCell
            else {
                fatalError()
        }
        return cell
    }
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.topInset, left: kLeftRightInset, bottom: kTopBottomInset, right: kLeftRightInset)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = collectionView.bounds.size
        size.width = size.width - (kLeftRightInset * 2)
        size.height = size.height - (self.topInset + kTopBottomInset)
        return size
    }
    
}

extension HomeVC: UICollectionViewDelegate {

    // Needed to prevent collection view cells from highlighting the internal table view.
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
