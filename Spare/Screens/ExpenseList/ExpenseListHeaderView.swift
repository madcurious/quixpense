//
//  ExpenseListHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 29/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kTopPadding = CGFloat(30)
private let kBottomPadding = CGFloat(50)
private let kLeftRightPadding = CGFloat(10)
private let kLabelVerticalSpacing = CGFloat(0)

class ExpenseListHeaderView: UIView {

    var nameLabel = ExpenseListHeaderView.newNameLabel()
    var detailLabel = ExpenseListHeaderView.newDetailLabel()
    
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
        label.font = Font.ExpenseListHeaderNameLabel
        label.textColor = Color.UniversalTextColor
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        return label
    }
    
    class func newDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.ExpenseListHeaderDetailLabel
        label.textColor = Color.UniversalTextColor
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        return label
    }
    
    override func layoutSubviews() {
        let widthForText = self.bounds.size.width - kLeftRightPadding * 2
        let maxTextSize = CGSizeMake(widthForText, CGFloat.max)
        
        let nameLabelSize = self.nameLabel.sizeThatFits(maxTextSize)
        self.nameLabel.frame = CGRectMake(self.bounds.size.width / 2 - nameLabelSize.width / 2,
                                          kTopPadding,
                                          nameLabelSize.width,
                                          nameLabelSize.height)
        
        let detailLabelSize = self.detailLabel.sizeThatFits(maxTextSize)
        self.detailLabel.frame = CGRectMake(self.bounds.size.width / 2 - detailLabelSize.width / 2,
                                            self.nameLabel.frame.origin.y + self.nameLabel.bounds.size.height + kLabelVerticalSpacing,
                                            detailLabelSize.width,
                                            detailLabelSize.height)
        
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
        let widthForText = UIScreen.mainScreen().bounds.size.width - kLeftRightPadding * 2
        let maxTextSize = CGSizeMake(widthForText, CGFloat.max)
        
        let nameLabel = self.newNameLabel()
        nameLabel.text = categoryName
        let nameLabelSize = nameLabel.sizeThatFits(maxTextSize)
        
        let detailLabel = self.newDetailLabel()
        detailLabel.text = detailText
        let detailLabelSize = detailLabel.sizeThatFits(maxTextSize)
        
        let height = kTopPadding + nameLabelSize.height + kLabelVerticalSpacing + detailLabelSize.height + kBottomPadding
        return height
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "nameLabel.text")
        self.removeObserver(self, forKeyPath: "detailLabel.text")
    }

}
