//
//  YSTextViewController.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/11/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSTextViewController.h"

@interface YSTextViewController () {
    
}

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *panelLabel;

@end

@implementation YSTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString* path = [[NSBundle mainBundle] pathForResource:@"silver_key"
                                                         ofType:@"txt"];
        NSString* content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_textView setText:content];
        });
    });

    [self observeBarLocationForTextView:_textView withBlock:^(CGPoint location, NSInteger line) {
        self.panelText.text = [NSString stringWithFormat:@"line %d", (NSInteger) line];
    }];
}

@end
