//
//  SPRFormCell.m
//  Spare
//
//  Created by Matt Quiros on 5/15/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRFormCell.h"

@implementation SPRFormCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
