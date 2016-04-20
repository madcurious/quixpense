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

// Libraries
#import <Crashlytics/Crashlytics.h>
#import "GAI.h"
#import "GAIFields.h"

@implementation SPRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up Crashlytics.
    [Crashlytics startWithAPIKey:@"5777ab02ad26fe0af3227a87ff1a25c1314bab82"];
    
    // Set up Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Track the start of the session.
    id tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-51765151-1"];
    [tracker set:kGAISessionControl value:@"start"];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Track the end of the session.
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAISessionControl value:@"end"];
}

@end
