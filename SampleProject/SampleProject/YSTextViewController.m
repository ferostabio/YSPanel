//
//  YSTextViewController.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/11/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSTextViewController.h"
#import "UIScrollView+YSPanel.h"

@interface YSTextViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation YSTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"silver_key" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            _textView.text = content;
        });
    });
    
    // Quick and dirty custom view example (centered)
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    v.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    v.layer.cornerRadius = v.frame.size.width / 2;
    v.layer.masksToBounds = YES;
    
    UILabel *l = [[UILabel alloc] initWithFrame:v.frame];
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    [v addSubview:l];
    
    [_textView addTextViewPanelWithBlock:^(CGPoint location, NSInteger line) {
        l.text = [NSString stringWithFormat:@"%d", line];
    }];
    
    _textView.panelView.customView = v;
    _textView.panelView.centered = YES;
}

@end
