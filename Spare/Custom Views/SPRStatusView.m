//
//  SPRStatusView.m
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRStatusView.h"

@interface SPRStatusView ()

@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UILabel *noResultsLabel;
@property (nonatomic) CGFloat maxContentWidth;
@property (strong, nonatomic) NSArray *subdisplays;

@end

static CGFloat kSidePadding = 20;

@implementation SPRStatusView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.alpha = 0;
        
        _noResultsLabel = [SPRStatusView label];
        _noResultsLabel.alpha = 0;
        
        [self addSubview:_loadingView];
        [self addSubview:_noResultsLabel];
        
        _subdisplays = @[_loadingView, _noResultsLabel];
        
        _maxContentWidth = self.frame.size.width - kSidePadding * 2;
    }
    return self;
}

- (void)setNoResultsText:(NSString *)noResultsText
{
    _noResultsText = noResultsText;
    self.noResultsLabel.text = noResultsText;
}

- (void)layoutSubviews
{
    CGFloat loadingViewX = self.frame.size.width / 2 - self.loadingView.frame.size.width / 2;
    CGFloat loadingViewY = self.frame.size.height / 2 - self.loadingView.frame.size.height / 2;
    self.loadingView.frame = CGRectMake(loadingViewX, loadingViewY, CGRectGetMaxX(self.loadingView.frame), CGRectGetMaxY(self.loadingView.frame));
    
    CGSize noResultsLabelSize = [self.noResultsLabel sizeThatFits:CGSizeMake(self.maxContentWidth, CGFLOAT_MAX)];
    CGFloat noResultsLabelX = self.frame.size.width / 2 - self.maxContentWidth / 2;
    CGFloat noResultsLabelY = self.frame.size.height / 2 - noResultsLabelSize.height / 2;
    self.noResultsLabel.frame = CGRectMake(noResultsLabelX, noResultsLabelY, self.maxContentWidth, noResultsLabelSize.height);
}

- (void)setStatus:(SPRStatusViewStatus)status
{
    UIView *currentDisplay = self.subdisplays[_status];
    
    _status = status;
    
    if (status == SPRStatusViewStatusLoading) {
        if (currentDisplay == self.loadingView) {
            return;
        }
        
        [self.loadingView startAnimating];
        
        [UIView animateWithDuration:0.25f animations:^{
            currentDisplay.alpha = 0;
            [UIView animateWithDuration:0.25f animations:^{
                self.loadingView.alpha = 1;
            }];
        }];
    } else {
        [self.loadingView stopAnimating];
    }
    
    if (status == SPRStatusViewStatusNoResults) {
        if (currentDisplay == self.noResultsLabel) {
            return;
        }
        [UIView animateWithDuration:0.25f animations:^{
            currentDisplay.alpha = 0;
            [UIView animateWithDuration:0.25f animations:^{
                self.noResultsLabel.alpha = 1;
            }];
        }];
    }
}

- (void)fadeOutAndRemoveFromSuperview
{
    UIView *currentDisplay = self.subdisplays[self.status];
    [UIView animateWithDuration:0.25f animations:^{
        currentDisplay.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (UILabel *)label
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

@end
