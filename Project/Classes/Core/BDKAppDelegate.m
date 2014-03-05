//
//  BDKAppDelegate.m
//  BDKUntappd
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKAppDelegate.h"

#import "BDKAuthViewController.h"
#import "BDKBeersViewController.h"

#import <BDKUntappd/BDKUntappd.h>

@interface BDKAppDelegate () <BDKAuthViewControllerDelegate>

- (void)configureUntappd;
- (void)showLoginFlow;
- (void)showBeersFlow;

@end

@implementation BDKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self configureUntappd];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"BDKUntappdAccessToken"];
    if (accessToken) {
        self.untappd.accessToken = accessToken;
        [self showBeersFlow];
    } else {
        [self showLoginFlow];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Methods

- (void)configureUntappd {
    NSString *secretsPath = [[NSBundle mainBundle] pathForResource:@"BDKUntappdSecrets" ofType:@"plist"];
    NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:secretsPath];
    NSString *clientId = secrets[@"BDKUntappdClientId"];
    NSString *clientSecret = secrets[@"BDKUntappdClientSecret"];
    NSString *redirectUrl = secrets[@"BDKUntappdRedirectUrl"];
    self.untappd = [[BDKUntappd alloc] initWithClientId:clientId clientSecret:clientSecret redirectUrl:redirectUrl];
}

- (void)showLoginFlow {
    BDKAuthViewController *webVC = [BDKAuthViewController new];
    webVC.request = [self.untappd authenticationURLRequest];
    webVC.redirectUrl = self.untappd.redirectUrl;
    webVC.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    self.window.rootViewController = nav;
}

- (void)showBeersFlow {
    BDKBeersViewController *beersVC = [BDKBeersViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:beersVC];
    self.window.rootViewController = nav;
}

#pragma mark - BDKAuthViewControllerDelegate

- (void)authViewController:(BDKAuthViewController *)viewController receivedAuthCode:(NSString *)authCode {
    [self.untappd authorizeForAccessCode:authCode completion:^(id responseObject, NSError *error) {
        // For those following along at home, don't do this. Put it in Keychain instead.
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"response"][@"access_token"] forKey:@"BDKUntappdAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showBeersFlow];
    }];
}

@end
