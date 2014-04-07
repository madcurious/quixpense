//
//  SPRManagedDocument.m
//  Spare
//
//  Created by Matt Quiros on 3/27/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRManagedDocument.h"

@interface SPRManagedDocument ()

@property (nonatomic) BOOL exists;

@end

@implementation SPRManagedDocument

+ (instancetype)sharedDocument
{
    static SPRManagedDocument *sharedDocument = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Build the document URL.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *documentName = @"SpareUIManagedDocument";
        NSURL *documentURL = [documentsDirectory URLByAppendingPathComponent:documentName];
        
        sharedDocument = [[SPRManagedDocument alloc] initWithFileURL:documentURL];
    });
    return sharedDocument;
}

- (id)initWithFileURL:(NSURL *)url
{
    if (self = [super initWithFileURL:url]) {
        _exists = [[NSFileManager defaultManager] fileExistsAtPath:url.path];
    }
    return self;
}

- (void)prepareWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    __block BOOL successful;
    
    if (self.exists) {
        [self openWithCompletionHandler:^(BOOL success) {
            successful = success;
            
            if (success) {
                if (self.documentState != UIDocumentStateNormal) {
                    successful = NO;
                }
            }
            completionHandler(successful);
        }];
    } else {
        [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            successful = success;
            
            if (success) {
                if (self.documentState != UIDocumentStateNormal) {
                    successful = NO;
                }
            }
            completionHandler(successful);
        }];
    }
}

@end
