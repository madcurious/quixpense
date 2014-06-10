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

@implementation SPRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"5777ab02ad26fe0af3227a87ff1a25c1314bab82"];
    return YES;
}

@end
