//
//  SPRStatusView.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPRStatusViewStatus)
{
    SPRStatusViewStatusLoading = 0,
    SPRStatusViewStatusNoResults = 1,
};

@interface SPRStatusView : UIView

@property (nonatomic) SPRStatusViewStatus status;

@property (strong, nonatomic) NSString *noResultsText;

- (void)fadeOutAndRemoveFromSuperview;

@end
