//
//  SPRCategoryHeaderCell.h
//  Spare
//
//  Created by Matt Quiros on 5/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategory;

@interface SPRCategoryHeaderCell : UITableViewCell

@property (weak, nonatomic) SPRCategory *category;

+ (CGFloat)heightForCategory:(SPRCategory *)category;

@end
