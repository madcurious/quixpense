//
//  SPRColorChooserViewController.h
//  Spare
//
//  Created by Matt Quiros on 3/26/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPRColorChooserViewControllerDelegate <NSObject>

- (void)colorChooserDidSelectColorNumber:(NSInteger)colorNumber;

@end

@interface SPRColorChooserViewController : UICollectionViewController

@property (nonatomic) NSInteger selectedColorNumber;
@property (weak, nonatomic) id<SPRColorChooserViewControllerDelegate> delegate;

@end
