//
//  SPRAppDelegate.m
//  Spare
//
//  Created by Matt Quiros on 3/22/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRAppDelegate.h"

// Objects
#import "SPRManagedDocument.h"

@implementation SPRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [document prepareWithCompletionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"Can't prepare managed document");
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return YES;
}

@end
