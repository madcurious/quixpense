//
//  HomeVC2.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

class HomeVC2: MDStatefulViewController {
    
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
    
    let forwardButton: CustomButton = {
        let forwardButton = CustomButton(attributedText: NSAttributedString(string: Icon.Forward.rawValue,
            attributes: [
                NSForegroundColorAttributeName : Color.UniversalTextColor,
                NSFontAttributeName : Font.icon(18)
            ]))
        return forwardButton
    }()
    
    let periodizationButton = PeriodizationButton()
    
    override var primaryView: UIView {
        return self.pageViewController.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .Bottom
        
        self.pageViewController.view.backgroundColor = Color.UniversalBackgroundColor
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.showView(.Loading)
        
        self.noResultsView.backgroundColor = Color.ScreenBackgroundColorLightGray
        
        self.periodizationButton.addTarget(self, action: #selector(handleSelectionOfPeriodization), forControlEvents: .ValueChanged)
        self.navigationItem.titleView = self.periodizationButton
        self.forwardButton.addTarget(self, action: #selector(handleTapOnForwardButton), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.forwardButton)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(handleUpdatesOnDataStore), name: NSManagedObjectContextDidSaveNotification, object: App.state.mainQueueContext)
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

extension HomeVC2: UIPageViewControllerDataSource {
    
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

extension HomeVC2: UIPageViewControllerDelegate {
    
    
    
}

