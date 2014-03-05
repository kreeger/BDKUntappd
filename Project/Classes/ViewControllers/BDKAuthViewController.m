//
//  BDKAuthViewController.m
//  BDKUntappd
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKAuthViewController.h"

@interface BDKAuthViewController () <UIWebViewDelegate>

@end

@implementation BDKAuthViewController

@synthesize webView = _webView;

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login to Untappd";
    [self.webView loadRequest:self.request];
}

#pragma mark - Properties

- (UIWebView *)webView {
    if (_webView) return _webView;
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *absoluteURL = [[request URL] absoluteString];
    if (![absoluteURL hasPrefix:self.redirectUrl]) return YES;
    
    NSString *queryString = [absoluteURL stringByReplacingOccurrencesOfString:self.redirectUrl withString:@""];
    queryString = [queryString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [pairs enumerateObjectsUsingBlock:^(NSString *pair, NSUInteger idx, BOOL *stop) {
        NSArray *components = [pair componentsSeparatedByString:@"="];
        params[components[0]] = components[1];
    }];
    
    if (params[@"code"]) {
        [self.delegate authViewController:self receivedAuthCode:params[@"code"]];
    }
    
    NSLog(@"REQUEST %@", [request URL]);
    return YES;
}

@end
