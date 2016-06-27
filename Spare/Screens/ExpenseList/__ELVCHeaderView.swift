//
//  __ELVCHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private let kTopPadding = CGFloat(30)
private let kBottomPadding = CGFloat(50)
private let kLeftRightPadding = CGFloat(10)
private let kLabelVerticalSpacing = CGFloat(0)

// Defined programatically because self-sizing reusable collection views are shit.
class __ELVCHeaderView: UICollectionReusableView {
    
    var nameLabel = __ELVCHeaderView.newNameLabel()
    var detailLabel = __ELVCHeaderView.newDetailLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(self.nameLabel, self.detailLabel)
        self.addObserver(self, forKeyPath: "nameLabel.text", options: [.New], context: nil)
        self.addObserver(self, forKeyPath: "detailLabel.text", options: [.New], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func newNameLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.ExpenseListHeaderViewNameLabel
        label.textColor = Color.ExpenseListHeaderViewTextColor
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        return label
    }
    
    class func newDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.ExpenseListHeaderViewDetailLabel
        label.textColor = Color.ExpenseListHeaderViewTextColor
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        return label
    }
    
    override func layoutSubviews() {
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.bounds.size.width,
                                kTopPadding + self.nameLabel.bounds.size.height + kLabelVerticalSpacing + self.detailLabel.bounds.size.height + kBottomPadding)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath
            else {
                return
        }
        
        let maxWidth = self.bounds.size.width - kLeftRightPadding * 2
        
        switch keyPath {
        case "nameLabel.text":
            self.nameLabel.frame = CGRectMake(kLeftRightPadding, kTopPadding, maxWidth, self.nameLabel.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max)).height)
            
        case "detailLabel.text":
            let y = self.nameLabel.frame.origin.y + self.nameLabel.bounds.size.height + kLabelVerticalSpacing
            self.detailLabel.frame = CGRectMake(kLeftRightPadding, y, maxWidth, self.detailLabel.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max)).height)
            
        default:
            return
        }
    }
    
    class func heightForCategoryName(categoryName: String, detailText: String) -> CGFloat {
        let dummyView = __ELVCHeaderView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, CGFloat.max))
        dummyView.nameLabel.text = categoryName
        dummyView.detailLabel.text = detailText
        dummyView.setNeedsLayout()
        dummyView.layoutIfNeeded()
        return dummyView.bounds.size.height
        
//        let labelWidth = UIScreen.mainScreen().bounds.size.width - kLeftRightPadding * 2
//        
//        let nameLabel = __ELVCHeaderView.newNameLabel()
//        nameLabel.text = categoryName
//        
//        let detailLabel = __ELVCHeaderView.newDetailLabel()
//        detailLabel.text = detailText
//        detailLabel.sizeToFit()
//        
//        return kTopPadding + nameLabel.sizeThatFits(CGSizeMake(labelWidth, CGFloat.max)).height + kLabelVerticalSpacing + detailLabel.sizeThatFits(CGSizeMake(labelWidth, CGFloat.max)).height + kBottomPadding
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "nameLabel.text")
        self.removeObserver(self, forKeyPath: "detailLabel.text")
    }
    
}
