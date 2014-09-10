//
//  YSWebViewController.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/11/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSWebViewController.h"
#import "UIScrollView+YSPanel.h"

@interface YSWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation YSWebViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    __weak YSWebViewController *weakSelf = self;
    [_webView.scrollView addDefaultPanelWithBlock:^(CGPoint location, CGFloat percent) {
        weakSelf.webView.scrollView.panelView.titleLabel.text = [NSString stringWithFormat:@"%.f%%", percent];
    }];
    
    NSURL *url = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Yog-Sothoth"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark UIWebView protocol

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end
