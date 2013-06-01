//
//  YSWebViewController.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/11/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSWebViewController.h"

@interface YSWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UILabel *panelLabel;

@end

@implementation YSWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[_webView scrollView] setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:@"http://en.wikipedia.org/wiki/Yog-Sothoth"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self observeBarLocation:_webView.scrollView withBlock:^(CGPoint location, CGFloat percent) {
        self.panelText.text = [NSString stringWithFormat:@"%d%%", (NSInteger) percent];
    }];
}

#pragma mark UIWebView protocol

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end
