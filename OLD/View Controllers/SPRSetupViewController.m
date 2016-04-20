//
//  SPRSetupViewController.m
//  Spare
//
//  Created by Matt Quiros on 4/8/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRSetupViewController.h"

// Objects
#import "SPRManagedDocument.h"

@interface SPRSetupViewController ()

@end

@implementation SPRSetupViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Put an activity indicator at the center.
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGFloat x = self.view.frame.size.width / 2 - activityIndicator.frame.size.width / 2;
    CGFloat y = self.view.frame.size.height / 2 - activityIndicator.frame.size.height / 2;
    activityIndicator.frame = CGRectMake(x, y, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
    
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    [document prepareWithCompletionHandler:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Categories can't be loaded." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
