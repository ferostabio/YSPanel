//
//  UIScrollView+YSPanel.h
//  SampleProject
//
//  Created by Federico Erostarbe on 04/09/14.
//  Copyright (c) 2014 Federico Erostarbe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSPanelView;

typedef void (^DefaultBlock)(CGPoint location, CGFloat percent);
typedef void (^TextViewBlock)(CGPoint location, NSInteger line);
typedef void (^TableViewBlock)(CGPoint location, NSIndexPath *indexPath);

@interface UIScrollView (YSPanel)

@property (nonatomic, strong) YSPanelView *panelView;

- (void) addDefaultPanelWithBlock:(DefaultBlock)block;
- (void) addTextViewPanelWithBlock:(TextViewBlock)block;
- (void) addTableViewPanelWithBlock:(TableViewBlock)block;

@end

@interface YSPanelView : UIView

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL centered;

@end