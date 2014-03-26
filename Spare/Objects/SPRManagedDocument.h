//
//  SPRManagedDocument.h
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRManagedDocument : UIManagedDocument

@property (nonatomic) BOOL exists;
@property (nonatomic, getter = isReady) BOOL ready;

- (void)prepareWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
