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
        self.addObserver(self, forKeyPath: "nameLabel.text", options: [.new], context: nil)
        self.addObserver(self, forKeyPath: "detailLabel.text", options: [.new], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func newNameLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.ExpenseListHeaderNameLabel
        label.textColor = Color.UniversalTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    class func newDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.ExpenseListHeaderDetailLabel
        label.textColor = Color.UniversalTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    override func layoutSubviews() {
        let widthForText = self.bounds.size.width - kLeftRightPadding * 2
        let maxTextSize = CGSize(width: widthForText, height: CGFloat.greatestFiniteMagnitude)
        
        let nameLabelSize = self.nameLabel.sizeThatFits(maxTextSize)
        self.nameLabel.frame = CGRect(x: self.bounds.size.width / 2 - nameLabelSize.width / 2,
                                          y: kTopPadding,
                                          width: nameLabelSize.width,
                                          height: nameLabelSize.height)
        
        let detailLabelSize = self.detailLabel.sizeThatFits(maxTextSize)
        self.detailLabel.frame = CGRect(x: self.bounds.size.width / 2 - detailLabelSize.width / 2,
                                            y: self.nameLabel.frame.origin.y + self.nameLabel.bounds.size.height + kLabelVerticalSpacing,
                                            width: detailLabelSize.width,
                                            height: detailLabelSize.height)
        
        self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: self.bounds.size.width,
                                height: kTopPadding + self.nameLabel.bounds.size.height + kLabelVerticalSpacing + self.detailLabel.bounds.size.height + kBottomPadding)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath
            else {
                return
        }
        
        let maxWidth = self.bounds.size.width - kLeftRightPadding * 2
        
        switch keyPath {
        case "nameLabel.text":
            self.nameLabel.frame = CGRect(x: kLeftRightPadding, y: kTopPadding, width: maxWidth, height: self.nameLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height)
            
        case "detailLabel.text":
            let y = self.nameLabel.frame.origin.y + self.nameLabel.bounds.size.height + kLabelVerticalSpacing
            self.detailLabel.frame = CGRect(x: kLeftRightPadding, y: y, width: maxWidth, height: self.detailLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height)
            
        default:
            return
        }
    }
    
    class func heightForCategoryName(_ categoryName: String, detailText: String) -> CGFloat {
        let widthForText = UIScreen.main.bounds.size.width - kLeftRightPadding * 2
        let maxTextSize = CGSize(width: widthForText, height: CGFloat.greatestFiniteMagnitude)
        
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
