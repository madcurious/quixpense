//
//  __ELVCHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private let kTopPadding = CGFloat(10)
private let kBottomPadding = CGFloat(40)
private let kLeftRightPadding = CGFloat(10)
private let kLabelVerticalSpacing = CGFloat(0)

// Defined programatically because self-sizing reusable collection views are shit.
class __ELVCHeaderView: UICollectionReusableView {
    
    var nameLabel = __ELVCHeaderView.newNameLabel()
    var detailLabel = __ELVCHeaderView.newDetailLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(self.nameLabel, self.detailLabel)
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
        let maxWidth = self.bounds.size.width - kLeftRightPadding * 2
        
        self.nameLabel.frame = CGRectMake(kLeftRightPadding,
                                          kTopPadding,
                                          maxWidth,
                                          self.nameLabel.sizeThatFits(CGSizeMax).height)
        self.detailLabel.frame = CGRectMake(kLeftRightPadding,
                                            self.nameLabel.frame.origin.y + self.nameLabel.bounds.size.height + kLabelVerticalSpacing,
                                            maxWidth,
                                            self.detailLabel.sizeThatFits(CGSizeMax).height)
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.bounds.size.width,
                                kTopPadding + self.nameLabel.bounds.size.height + kLabelVerticalSpacing + self.detailLabel.bounds.size.height + kBottomPadding)
    }
    
    class func heightForCategoryName(categoryName: String, detailText: String) -> CGFloat {
        let dummyView = __ELVCHeaderView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, CGFloat.max))
        dummyView.nameLabel.text = categoryName
        dummyView.detailLabel.text = detailText
        dummyView.setNeedsLayout()
        dummyView.layoutIfNeeded()
        return dummyView.bounds.size.height
    }
    
}
