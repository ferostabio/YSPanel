//
//  YSPanel
//  YSPanelViewController.h
//  Created by Federico Erostarbe on 5/11/13.
//
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM( NSUInteger, YSPanelObservingType ) {
    YSPanelObservingTypeDefault,
    YSPanelObservingTypeTextView,
    YSPanelObservingTypeTableView
};

typedef void (^DefaultBlock)(CGPoint location, CGFloat percent);
typedef void (^TextViewBlock)(CGPoint location, NSInteger line);
typedef void (^TableViewBlock)(CGPoint location, NSIndexPath *indexPath);

@interface YSPanelViewController : UIViewController <UIScrollViewDelegate> {
    DefaultBlock defaultBlock;
    TextViewBlock textViewBlock;
    TableViewBlock tableViewBlock;
}
@property (strong) UIScrollView *scrollView;
@property (strong) UIView *infoPanel;
@property (strong) IBOutlet UILabel *panelText;

- (void) observeBarLocation:(UIScrollView *)sv withBlock:(DefaultBlock)block;
- (void) observeBarLocationForTextView:(UITextView *)sv withBlock:(TextViewBlock)block;
- (void) observeBarLocationForTableView:(UITableView *)sv withBlock:(TableViewBlock)block;
- (void) attachView:(UIView *)v centered:(BOOL)flag;

@end
