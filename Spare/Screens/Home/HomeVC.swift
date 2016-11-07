//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

class HomeVC: MDOperationViewController {
    
    let pageViewController: UIPageViewController = {
        let pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [
            UIPageViewControllerOptionInterPageSpacingKey : 20
            ])
        pager.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        return pager
    }()
    
    let currentDate = Date()
    var pageData = [PageData]()
    
    let nowButton = Button(string: "Now", font: Font.ModalBarButtonText, textColor: Color.UniversalTextColor)
    let periodizationButton = PeriodizationButton()
    let customLoadingView = OperationVCLoadingView()
    
    override var primaryView: UIView {
        return self.pageViewController.view
    }
    
    override var loadingView: UIView {
        return self.customLoadingView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Spare"
        self.navigationItem.title = "Home"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glb_applyGlobalVCSettings(self)
        self.edgesForExtendedLayout = .bottom
        
        self.pageViewController.view.backgroundColor = Color.UniversalBackgroundColor
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.showView(.loading)
        
        self.noResultsView.backgroundColor = Color.UniversalBackgroundColor
        
        self.periodizationButton.addTarget(self, action: #selector(handleSelectionOfPeriodization), for: .valueChanged)
        self.nowButton.addTarget(self, action: #selector(handleTapOnNowButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.periodizationButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.nowButton)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleFinishedInitializingCoreDataStack), name: Notifications.LoadAppVCFinishedLoadingCoreDataStack, object: nil)
    }
    
    override func makeOperation() -> MDOperation? {
        guard App.coreDataStack != nil
            else {
                return nil
        }
        
        return MDBlockOperation {[unowned self] in
            CategoryProvider.initialize(completion: {[unowned self] in
                self.operationQueue.addOperation(
                    MakePagesOperation(currentDate: self.currentDate,
                                       periodization: App.selectedPeriodization,
                                       startOfWeek: App.selectedStartOfWeek,
                                       count: 10,
                                       pageOffset: self.pageData.count)
                        
                        .onSuccess({[unowned self] result in
                            self.pageData.insert(contentsOf: result as! [PageData], at: 0)
                            
                            if self.currentView != .primary {
                                // Populate the pageVC with a junk DateRange so that programatically scrolling to the last page works.
                                self.pageViewController.setViewControllers([HomePageVC(pageData: PageData())], direction: .forward, animated: false, completion: nil)
                                
                                self.scrollToLastPage(animated: false)
                                self.showView(.primary)
                            }
                            })
                )
            })
        }
    }
    
    func scrollToLastPage(animated: Bool) {
        guard let lastData = self.pageData.last,
            let currentPage = self.pageViewController.viewControllers?.first as? HomePageVC,
            currentPage.pageData.dateRange != lastData.dateRange
            else {
                return
        }
        
        self.pageViewController.setViewControllers([HomePageVC(pageData: lastData)], direction: .forward, animated: animated, completion: nil)
    }
    
    func handleFinishedInitializingCoreDataStack() {
        self.runOperation()
    }
    
    func handleTapOnNowButton() {
        self.scrollToLastPage(animated: true)
    }
    
    func handleSelectionOfPeriodization() {
        App.selectedPeriodization = self.periodizationButton.selectedPeriodization
        self.pageData = []
        self.runOperation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension HomeVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? HomePageVC,
            let currentIndex = self.pageData.index(of: currentPage.pageData)
            else {
                return nil
        }
        
        let previousIndex = currentIndex - 1
        if previousIndex > 0 {
            // Start another create operation if nearing the end.
            if let op = self.makeOperation(),
                previousIndex == 5 {
                self.operationQueue.addOperation(op)
            }
            
            let previousPage = HomePageVC(pageData: self.pageData[previousIndex])
            return previousPage
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentPage = self.pageViewController.viewControllers?.first as? HomePageVC,
            let currentIndex = self.pageData.index(of: currentPage.pageData)
            else {
                return nil
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < self.pageData.count {
            let previousPage = HomePageVC(pageData: self.pageData[nextIndex])
            return previousPage
        }
        return nil
    }
    
}

extension HomeVC: UIPageViewControllerDelegate {
    
    
    
}

