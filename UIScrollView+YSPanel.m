//
//  UIScrollView+YSPanel.m
//  SampleProject
//
//  Created by Federico Erostarbe on 04/09/14.
//  Copyright (c) 2014 Federico Erostarbe. All rights reserved.
//

#import "UIScrollView+YSPanel.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, YSPanelObservingStatus) {
    YSPanelObservingStatusNone,
    YSPanelObservingStatusDefault,
    YSPanelObservingStatusTextView,
    YSPanelObservingStatusTableView
};

static char UIScrollViewYSPanelView;

#define kDefaultPanelFrame CGRectMake(0.0f, 0.0f, 50.0f, 30.9f)
#define kRightPadding 5.0f

@interface YSPanelView ()

@property (nonatomic, copy) DefaultBlock defaultBlock;
@property (nonatomic, copy) TextViewBlock textViewBlock;
@property (nonatomic, copy) TableViewBlock tableViewBlock;
@property (nonatomic, assign) YSPanelObservingStatus ObservingStatus;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation UIScrollView (YSPanel)

@dynamic panelView;

- (void)setPanelView:(YSPanelView *)panelView
{
    [self willChangeValueForKey:@"YSPanelView"];
    objc_setAssociatedObject(self, &UIScrollViewYSPanelView,
                             panelView,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"YSPanelView"];
}

- (YSPanelView *)panelView {
    return objc_getAssociatedObject(self, &UIScrollViewYSPanelView);
}

- (void) addDefaultPanelWithBlock:(DefaultBlock)block
{
    [self addPanelWithBlock:block status:YSPanelObservingStatusDefault];
}

- (void) addTextViewPanelWithBlock:(TextViewBlock)block
{
    [self addPanelWithBlock:block status:YSPanelObservingStatusTextView];
}

- (void) addTableViewPanelWithBlock:(TableViewBlock)block
{
    [self addPanelWithBlock:block status:YSPanelObservingStatusTableView];
}

- (void) addPanelWithBlock:(id)block status:(YSPanelObservingStatus)status
{
    if (!self.panelView) {
        YSPanelView *view = [[YSPanelView alloc] initWithFrame:kDefaultPanelFrame];
        view.scrollView = self;
        view.ObservingStatus = status;
        
        if (status == YSPanelObservingStatusDefault) {
            view.defaultBlock = block;
        } else if (status == YSPanelObservingStatusTextView) {
            view.textViewBlock = block;
        } else if (status == YSPanelObservingStatusTableView) {
            view.tableViewBlock = block;
        }
        
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75f];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.numberOfLines = 0;
        [view addSubview:label];
        
        view.titleLabel = label;
        self.panelView = view;
        
        [self addObserver:view
               forKeyPath:@"contentOffset"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
}

- (UIView *) indicator
{
    return self.subviews.lastObject;
}

@end

@implementation YSPanelView

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    [self updateFrame];
    [self answerBlock:[self indicatorCenter]];
}

- (void) updateFrame
{
    UIView *indicator = _scrollView.indicator;
    if (!self.superview) {
        [indicator addSubview:self];
    }
    
    CGRect infoPanelFrame = self.frame;
    infoPanelFrame.origin.x = self.x;
    infoPanelFrame.origin.y = [self y:indicator.frame];
    
    self.frame = infoPanelFrame;
}

#pragma mark - UI

- (CGPoint) indicatorCenter
{
    CGPoint p = CGPointZero;
    if ([_scrollView isKindOfClass:[UIScrollView class]]) {
        CGRect indicatorFrame = _scrollView.indicator.frame;
        p = CGPointMake(0, indicatorFrame.origin.y + indicatorFrame.size.height / 2);
    }
    return p;
}

- (CGFloat) x
{
    CGFloat x;
    if (_centered) {
        x = (_scrollView.frame.size.width / 2 + self.frame.size.width / 2 ) * (-1);
    } else {
        x = self.frame.size.width * (-1) - kRightPadding;
    }
    return x;
}

- (CGFloat) y:(CGRect)indicatorFrame
{
    CGRect infoPanelFrame = self.frame;
    return indicatorFrame.size.height / 2 - infoPanelFrame.size.height / 2;
}

#pragma -

- (void) setCustomView:(UIView *)view
{
    _customView = view;
    
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    if (_customView != nil && _customView.superview == nil) {
        self.layer.cornerRadius = 0.0f;
        self.backgroundColor = [UIColor clearColor];
        self.frame = _customView.frame;
        
        [self addSubview:_customView];
    }
}

- (void) willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil && _ObservingStatus != YSPanelObservingStatusNone) {
        _ObservingStatus = YSPanelObservingStatusNone;
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

#pragma mark - Blocks

- (void) answerBlock:(CGPoint)p
{
    if (_ObservingStatus == YSPanelObservingStatusDefault) {
        [self answerDefaultBlock:p];
    } else if (_ObservingStatus == YSPanelObservingStatusTextView) {
        [self answerTextViewBlock:p];
    } else if (_ObservingStatus == YSPanelObservingStatusTableView) {
        [self answerTableViewBlock:p];
    }
}

- (void) answerDefaultBlock:(CGPoint)p
{
    if (_defaultBlock != nil) {
        CGFloat contentOffsetY = _scrollView.contentOffset.y;
        CGFloat contentHeight = _scrollView.contentSize.height;
        CGFloat frameHeight = _scrollView.frame.size.height;
        
        CGFloat percent = (contentOffsetY / (contentHeight - frameHeight)) * 100;
        if (percent < 0) percent = 0; else if (percent > 100) percent = 100;
        
        _defaultBlock(p, percent);
    }
}

- (void) answerTextViewBlock:(CGPoint)p
{
    if (_textViewBlock != nil && [_scrollView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *) _scrollView;
        NSInteger lines = textView.contentSize.height / textView.font.lineHeight;
        CGFloat line = roundf(p.y / textView.font.lineHeight);
        if (line < 1) line = 1; else if (line > lines) line = lines;
        
        _textViewBlock(p, (NSInteger) line);
    }
}

- (void) answerTableViewBlock:(CGPoint)p
{
    if (_tableViewBlock != nil && [_scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *) _scrollView;
        CGFloat height = tableView.contentSize.height;
        if (p.y < 0.0f) p.y = 0.0f; else if (p.y > height) p.y = height - 1.0f;
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        
        _tableViewBlock(p, indexPath);
    }
}

@end
