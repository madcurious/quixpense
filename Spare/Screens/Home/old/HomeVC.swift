//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

class HomeVC: MDStatefulViewController {
    
    let pageViewController: UIPageViewController = {
        let pager = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: [
            UIPageViewControllerOptionInterPageSpacingKey : 20
            ])
        pager.setViewControllers([UIViewController()], direction: .Forward, animated: false, completion: nil)
        return pager
    }()
    
    let currentDate = NSDate()
    var isCreatingSummaries = false
    var summaries = [Summary]()
    
    let forwardButton = Button(string: "Now", font: Font.ModalBarButtonText, textColor: Color.UniversalTextColor)
    let periodizationButton = PeriodizationButton()
    let customRetryView = NoCategoriesView.instantiateFromNib()
    
    override init() {
        super.init()
        self.title = "Spare"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var primaryView: UIView {
        return self.pageViewController.view
    }
    
    override var retryView: MDRetryView {
        return self.customRetryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .Bottom
        
        self.pageViewController.view.backgroundColor = Color.UniversalBackgroundColor
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.UniversalBackgroundColor
        
        self.periodizationButton.addTarget(self, action: #selector(handleSelectionOfPeriodization), forControlEvents: .ValueChanged)
        self.forwardButton.addTarget(self, action: #selector(handleTapOnForwardButton), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.periodizationButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.forwardButton)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(handleUpdatesOnDataStore), name: NSManagedObjectContextDidSaveNotification, object: App.mainQueueContext)
    }
    
    override func buildOperation() -> MDOperation? {
        return CreateSummariesOperation(baseDate: self.currentDate,
            periodization: App.state.selectedPeriodization,
            startOfWeek: App.state.selectedStartOfWeek,
            count: 10,
            startingPage: self.summaries.count)
            
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
                
                self.summaries.insertContentsOf(newSummaries, at: 0)
                
                if self.currentView != .Primary {
                    self.scrollToLastSummary(animated: false)
                    self.showView(.Primary)
                }
                
                })
    }
    
    override func buildFailBlock() -> (ErrorType -> Void) {
        return {[unowned self] error in
            guard let customError = error as? Error
                else {
                    fatalError("Got an error not customised: \(error as NSError)")
            }
            self.customRetryView.error = customError
            self.showView(.Retry)
        }
    }
    
    func scrollToLastSummary(animated animated: Bool) {
        guard let lastSummary = self.summaries.last
            else {
                return
        }
        self.pageViewController.setViewControllers([SummaryVC(summary: lastSummary)], direction: .Forward, animated: animated, completion: nil)
    }
    
    func handleUpdatesOnDataStore() {
        guard let summaryVC = self.pageViewController.viewControllers?.first as? SummaryVC
            else {
                return
        }
        summaryVC.collectionView.reloadData()
    }
    
    func handleTapOnForwardButton() {
        if let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC,
            let currentIndex = self.summaries.indexOf(currentPage.summary)
            where currentIndex == self.summaries.count - 1 {
            return
        }
        
        self.scrollToLastSummary(animated: true)
    }
    
    func handleSelectionOfPeriodization() {
        App.state.selectedPeriodization = self.periodizationButton.selectedPeriodization
        self.summaries = []
        self.runOperation()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension HomeVC: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC,
            let currentIndex = self.summaries.indexOf(currentPage.summary)
            else {
                return nil
        }
        
        let previousIndex = currentIndex - 1
        if previousIndex > 0 {
            // Start another create operation if nearing the end.
            if let op = self.buildOperation()
                where previousIndex == 5 {
                self.operationQueue.addOperation(op)
            }
            
            let previousPage = SummaryVC(summary: self.summaries[previousIndex])
            return previousPage
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? SummaryVC,
            let currentIndex = self.summaries.indexOf(currentPage.summary)
            else {
                return nil
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < self.summaries.count {
            let previousPage = SummaryVC(summary: self.summaries[nextIndex])
            return previousPage
        }
        return nil
    }
    
}

extension HomeVC: UIPageViewControllerDelegate {
    
    
    
}

