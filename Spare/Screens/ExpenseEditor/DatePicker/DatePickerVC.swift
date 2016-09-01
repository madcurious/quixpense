//
//  DatePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private enum ViewID: String {
    case PageCell = "PageCell"
}

private enum PageDirection {
    case Previous, Next
}

protocol DatePickerVCDelegate {
    func datePickerDidSelectDate(date: NSDate)
}

class DatePickerVC: UIViewController {
    
    static let selectedDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    static let monthLabelFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    
    let customView = __DPVCView.instantiateFromNib() as __DPVCView
    let pageVC = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 10])
    
    var months = [NSDate]()
    let dayCountCache = NSCache()
    let fillerCountCache = NSCache()
    
    var selectedDate: NSDate
    var delegate: DatePickerVCDelegate?
    var shouldUpdateDelegate = false
    
    init(selectedDate: NSDate, delegate: DatePickerVCDelegate?) {
        self.selectedDate = selectedDate
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        self.embedChildViewController(self.pageVC, toView: self.customView.pageVCContainer)
        
        // Add the current month to the data source.
        let currentMonth = self.firstDayOfMonthInDate(self.selectedDate)
        let previousMonths = self.generateMonthsFromDate(self.selectedDate, forPageDirection: .Previous)
        self.months.appendContentsOf(previousMonths)
        self.months.append(currentMonth)
        let nextMonths = self.generateMonthsFromDate(self.selectedDate, forPageDirection: .Next)
        self.months.appendContentsOf(nextMonths)
        
        // Add the current month to the page VC.
        let initialPage = MonthPageVC(month: currentMonth, globallySelectedDate: self.selectedDate)
        self.pageVC.setViewControllers([initialPage], direction: .Forward, animated: false, completion: nil)
        
        // Initially select the current month.
        self.customView.selectedDateLabel.text = DatePickerVC.selectedDateFormatter.stringFromDate(self.selectedDate)
        self.customView.monthLabel.text = DatePickerVC.monthLabelFormatter.stringFromDate(currentMonth)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
        
        self.customView.previousButton.addTarget(self, action: #selector(handleTapOnPreviousButton), forControlEvents: .TouchUpInside)
        self.customView.nextButton.addTarget(self, action: #selector(handleTapOnNextButton), forControlEvents: .TouchUpInside)
        
        // Listen to date selections in month pages.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleDateSelectionNotification(_:)), name: NSNotificationName.MonthPageVCDidSelectDate.string(), object: nil)
    }
    
    private func generateMonthsFromDate(date: NSDate, forPageDirection pageDirection: PageDirection) -> [NSDate] {
        // Use the first day of the month as the base date.
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: date)
        components.day = 1
        let baseMonth = calendar.dateFromComponents(components)!
        
        var months = [NSDate]()
        for i in 1 ... 6 {
            let increment = pageDirection == .Previous ? -(i) : i
            let newMonth = calendar.dateByAddingUnit(.Month, value: increment, toDate: baseMonth, options: [])!
            let insertionIndex = pageDirection == .Previous ? 0 : months.count
            months.insert(newMonth, atIndex: insertionIndex)
        }
        
        return months
    }
    
    func firstDayOfMonthInDate(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: date)
        components.day = 1
        return calendar.dateFromComponents(components)!
    }
    
    func updateMonthLabelForDate(date: NSDate) {
        self.customView.monthLabel.text = DatePickerVC.monthLabelFormatter.stringFromDate(date)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

// MARK: - Target actions
extension DatePickerVC {
    
    func handleTapOnDimView() {
        if let delegate = self.delegate
            where self.shouldUpdateDelegate == true {
            delegate.datePickerDidSelectDate(self.selectedDate)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleTapOnPreviousButton() {
        let currentPage = self.pageVC.viewControllers!.first as! MonthPageVC
        let indexOfMonth = self.months.indexOf(currentPage.month)!
        let previousPage = MonthPageVC(month: self.months[indexOfMonth - 1], globallySelectedDate: self.selectedDate)
        self.pageVC.setViewControllers([previousPage], direction: .Reverse, animated: false, completion: nil)
        self.updateMonthLabelForDate(previousPage.month)
    }
    
    func handleTapOnNextButton() {
        let currentPage = self.pageVC.viewControllers!.first as! MonthPageVC
        let indexOfMonth = self.months.indexOf(currentPage.month)!
        let nextPage = MonthPageVC(month: self.months[indexOfMonth + 1], globallySelectedDate: self.selectedDate)
        self.pageVC.setViewControllers([nextPage], direction: .Forward, animated: false, completion: nil)
        self.updateMonthLabelForDate(nextPage.month)
    }
    
    func handleDateSelectionNotification(notification: NSNotification) {
        guard let selectedDate = notification.userInfo?["selectedDate"] as? NSDate
            where notification.name == NSNotificationName.MonthPageVCDidSelectDate.string()
            else {
                return
        }
        
        self.selectedDate = selectedDate
        self.customView.selectedDateLabel.text = DatePickerVC.selectedDateFormatter.stringFromDate(selectedDate)
        self.shouldUpdateDelegate = true
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension DatePickerVC: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MonthPageVC
        let index = self.months.indexOf(page.month)!
        
        var previousIndex: Int
        if index == 0 {
            // Generate more pages if needed.
            let moreMonths = self.generateMonthsFromDate(self.months[0], forPageDirection: .Previous)
            self.months.insertContentsOf(moreMonths, at: 0)
            
            previousIndex = moreMonths.count - 1
        } else {
            previousIndex = index - 1
        }
        
        let previousPage = MonthPageVC(month: self.months[previousIndex], globallySelectedDate: self.selectedDate)
        return previousPage
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MonthPageVC
        let currentIndex = self.months.indexOf(page.month)!
        
        if currentIndex == self.months.count - 1 {
            let moreMonths = self.generateMonthsFromDate(self.months[currentIndex], forPageDirection: .Next)
            self.months.appendContentsOf(moreMonths)
        }
        
        let nextPage = MonthPageVC(month: self.months[currentIndex + 1], globallySelectedDate: self.selectedDate)
        return nextPage
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension DatePickerVC: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let nextPage = pendingViewControllers.first as? MonthPageVC {
            self.updateMonthLabelForDate(nextPage.month)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPage = self.pageVC.viewControllers?.first as? MonthPageVC {
            self.updateMonthLabelForDate(currentPage.month)
        }
    }
    
}
