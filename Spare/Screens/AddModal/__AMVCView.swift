//
//  __AMVCView.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __AMVCView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        
        self.pageControl.numberOfPages = 2
        self.pageControl.pageIndicatorTintColor = Color.Gray200
        self.pageControl.currentPageIndicatorTintColor = Color.Gray900
        self.pageControl.userInteractionEnabled = false
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = Color.Gray100
    }
    
    func setupLayoutRulesForPages(firstPage: UIView, secondPage: UIView) {
        guard self.contentView.subviews.contains(firstPage) && self.contentView.subviews.contains(secondPage)
            else {
                return
        }
        
        let rules = [
            "H:|-0-[firstPage]-0-[secondPage]-0-|",
            "V:|-0-[firstPage]-0-|",
            "V:|-0-[secondPage]-0-|"
        ]
        let views = [
            "firstPage" : firstPage,
            "secondPage" : secondPage
        ]
        let constraints = NSLayoutConstraint.constraintsWithVisualFormatArray(rules, metrics: nil, views: views)
        
        UIView.disableAutoresizingMasksInViews(firstPage, secondPage)
        self.addConstraints(constraints)
        
        // Add the width Autolayout rules to the pages.
        let widthConstraint = NSLayoutConstraint(item: firstPage, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1, constant: 0)
        self.addConstraint(widthConstraint)
    }
    
}

extension __AMVCView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Keep track of old page values for event firing.
        let oldCurrentPage = self.pageControl.currentPage
        
        // Compute for the newCurrentPage.
        let pageWidth = self.scrollView.bounds.size.width
        let fractionalPage = Double(self.scrollView.contentOffset.x / pageWidth)
        self.pageControl.currentPage = lround(fractionalPage)
        
        if oldCurrentPage != self.pageControl.currentPage {
            self.pageControl.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
}
