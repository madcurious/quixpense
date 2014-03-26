//
//  SPRManagedDocument.m
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRManagedDocument.h"

@interface SPRManagedDocument ()

@property (strong, nonatomic) NSURL *documentURL;

@end

@implementation SPRManagedDocument

- (id)init
{
    // Build the document URL.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *documentName = @"SpareUIManagedDocument";
    NSURL *documentURL = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    if (self = [super initWithFileURL:documentURL]) {
        _documentURL = documentURL;
    }
    return self;
}

- (BOOL)exists
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:self.documentURL.path];
    return exists;
}

- (void)prepareWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    if (self.exists) {
        [self openWithCompletionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"Can't open document at %@", self.documentURL);
            }
            completionHandler(success);
        }];
    } else {
        [self saveToURL:self.documentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"Can't create document at %@", self.documentURL);
            }
            completionHandler(success);
        }];
    }
}

- (BOOL)isReady
{
    _ready = self.documentState == UIDocumentStateNormal;
    return _ready;
}

@end
