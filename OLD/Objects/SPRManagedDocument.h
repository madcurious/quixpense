//
//  SPRManagedDocument.h
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRManagedDocument : UIManagedDocument

@property (nonatomic, getter = isReady) BOOL ready;

+ (instancetype)sharedDocument;

- (void)prepareWithCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)saveWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
