//
//  YSPanel
//  YSPanelViewController.m
//  Created by Federico Erostarbe on 5/11/13.
//
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSPanelViewController.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_PANEL_WIDTH 70
#define DEFAULT_PANEL_HEIGHT 35
#define RIGHT_PADDING 5

@interface YSPanelViewController () {
	CGFloat initialHeightOfScrollIndicator;
    YSPanelObservingType observingType;
    BOOL panelCentered;
}

@end

@implementation YSPanelViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self attachDefaultView];
}

#pragma mark UIScrollView protocol

- (void) scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
    if (_infoPanel != nil && ![_infoPanel.layer superlayer]) {
        UIView *indicator = [[aScrollView subviews] lastObject];
		CGRect indicatorFrame = [indicator frame];

		initialHeightOfScrollIndicator = indicatorFrame.size.height;

		[[_infoPanel layer] setBackgroundColor:[[indicator layer] backgroundColor]];
		[[indicator layer] addSublayer:[_infoPanel layer]];

		CGRect infoPanelFrame = [_infoPanel frame];
        infoPanelFrame.origin.x = [self horizontalPositionForPanel];
		infoPanelFrame.origin.y = indicatorFrame.size.height / 2 - infoPanelFrame.size.height / 2;
		[_infoPanel setFrame:CGRectIntegral(infoPanelFrame)];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_infoPanel.layer removeFromSuperlayer];
}

#pragma mark Observers

- (void) observeBarLocation:(UIScrollView *)sv withBlock:(DefaultBlock)block
{
    observingType = YSPanelObservingTypeDefault;
    defaultBlock = block;
    [self addObserver:sv];
}

- (void) observeBarLocationForTextView:(UITextView *)sv withBlock:(TextViewBlock)block
{
    observingType = YSPanelObservingTypeTextView;
    textViewBlock = block;
    [self addObserver:sv];
}

- (void) observeBarLocationForTableView:(UITableView *)sv withBlock:(TableViewBlock)block
{
    observingType = YSPanelObservingTypeTableView;
    tableViewBlock = block;
    [self addObserver:sv];
}

#pragma mark KVO

- (void) addObserver:(UIScrollView *)sv
{
    _scrollView = sv;
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    CGPoint point = [self centerForScrollBar:_scrollView];
    [self answerBlock:point];
}

#pragma mark Blocks

- (void) answerBlock:(CGPoint)p
{
    if (observingType == YSPanelObservingTypeDefault) {
        [self answerDefaultBlock:p];
    } else if (observingType == YSPanelObservingTypeTextView) {
        [self answerTextViewBlock:p];
    } else if (observingType == YSPanelObservingTypeTableView) {
        [self answerTableViewBlock:p];
    }
}

- (void) answerDefaultBlock:(CGPoint)p
{
    if (defaultBlock != NULL) {
        CGFloat contentOffsetY = [_scrollView contentOffset].y;
        CGFloat contentHeight = [_scrollView contentSize].height;
        CGFloat frameHeight = [_scrollView frame].size.height;

        CGFloat percent = (contentOffsetY / (contentHeight - frameHeight)) * 100;
        if (percent < 0) percent = 0; else if (percent > 100) percent = 100;

        defaultBlock(p, percent);
    }

}

- (void) answerTextViewBlock:(CGPoint)p
{
    if (textViewBlock != NULL && [_scrollView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *) _scrollView;
        NSInteger lines = textView.contentSize.height / textView.font.lineHeight;
        CGFloat line = roundf(p.y / textView.font.lineHeight);
        if (line < 1) line = 1; else if (line > lines) line = lines;

        textViewBlock(p, (NSInteger) line);
    }
}

- (void) answerTableViewBlock:(CGPoint)p
{
    if (tableViewBlock != NULL && [_scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *) _scrollView;
        CGFloat height = tableView.contentSize.height;
        if (p.y < 0.0f) p.y = 0.0f; else if (p.y > height) p.y = height - 1.0f;
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        
        tableViewBlock(p, indexPath);
    }
}

#pragma mark Panel Position

- (CGPoint) centerForScrollBar:(UIScrollView *)v
{
    CGPoint p = CGPointZero;
    if (v != nil && [v isKindOfClass:[UIScrollView class]]) {
        UIView *indicator = [[v subviews] lastObject];
        CGRect indicatorFrame = [indicator frame];
        p = CGPointMake(0, indicatorFrame.origin.y + indicatorFrame.size.height / 2);
    }
    return p;
}

- (CGFloat) horizontalPositionForPanel
{
    CGFloat x;
    if (panelCentered) {
        x = (self.view.frame.size.width / 2 + _infoPanel.frame.size.width / 2 ) * (-1);
    } else {
        x = _infoPanel.frame.size.width * (-1) - RIGHT_PADDING;
    }
    return x;
}

#pragma mark View attaching

- (void) attachDefaultView
{
    CGRect frame = { 0, 0, DEFAULT_PANEL_WIDTH, DEFAULT_PANEL_HEIGHT };
    UIView *v = [[UIView alloc] initWithFrame:frame];

    _panelText = [[UILabel alloc] initWithFrame:frame];
    _panelText.backgroundColor = [UIColor blackColor];
    _panelText.textColor = [UIColor whiteColor];
    _panelText.textAlignment = NSTextAlignmentCenter;
    _panelText.font = [UIFont boldSystemFontOfSize:14.0];
    _panelText.alpha = 0.8;
    _panelText.layer.cornerRadius = 8.0;

    [v addSubview:_panelText];
    [self attachView:v centered:NO];
}

- (void) attachView:(UIView *)v centered:(BOOL)flag
{
    _infoPanel =  v;
    panelCentered = flag;
}

@end