//
//  SPRHomeTableViewCell.h
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OldSPRCategory;

@interface SPRHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) OldSPRCategory *category;

+ (CGFloat)heightForCategory:(OldSPRCategory *)category;

@end
