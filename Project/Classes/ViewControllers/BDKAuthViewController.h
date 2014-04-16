//
//  BDKUntappd // BDKAuthViewController.h
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@protocol BDKAuthViewControllerDelegate;

@interface BDKAuthViewController : UIViewController

@property (weak, nonatomic) id<BDKAuthViewControllerDelegate> delegate;
@property (readonly, strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *redirectUrl;
@property (strong, nonatomic) NSURLRequest *request;

@end

@protocol BDKAuthViewControllerDelegate <NSObject>

- (void)authViewController:(BDKAuthViewController *)viewController receivedAuthCode:(NSString *)authCode;

@end