//
//  BDKUntappd // BDKAppDelegate.m
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKAppDelegate.h"

#import "BDKAuthViewController.h"
#import "BDKDumbListViewController.h"
#import "BDKSearchViewController.h"

#import <BDKUntappd/BDKUntappd.h>

@interface BDKAppDelegate () <BDKAuthViewControllerDelegate>

@property (strong, nonatomic) NSArray *results;

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
    BDKAuthViewController *webVC = [[BDKAuthViewController alloc] init];
    webVC.request = [self.untappd authenticationURLRequest];
    webVC.redirectUrl = self.untappd.redirectUrl;
    webVC.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    self.window.rootViewController = nav;
}

- (void)showBeersFlow {
    BDKSearchViewController *workingListVC = [[BDKSearchViewController alloc] init];
    workingListVC.title = @"Beer search";
    [workingListVC setAlertTitle:@"Beer Search" description:@"Plug in your brew"];
    [workingListVC setPerformSearchBlock:^(NSString *query, void(^whenFinished)(NSArray *results)) {
        [self.untappd searchForBeer:query sortBy:BDKUntappdBeerSearchSortTypeMostCheckins completion:^(id responseObject, NSError *error) {
            self.results = responseObject;
            whenFinished(responseObject);
        }];
    }];
    [workingListVC setCellDisplayBlock:^(BDKUntappdBeer *beer, UITableViewCell *cell) {
        cell.textLabel.text = beer.name;
        cell.detailTextLabel.text = beer.brewery.name;
    }];
    [workingListVC setCellTappedBlock:^(NSIndexPath *indexPath) {
        BDKUntappdBeer *beer = self.results[indexPath.row];
        [self.untappd checkinToBeerID:beer.identifier foursquareLocationID:nil latitude:0 longitude:0 shout:@"Hahaha, nooner!" rating:3.5f postTo:BDKUntappdCheckinPostToTwitter completion:^(id responseObject, NSError *error) {
            NSLog(@"%@", responseObject);
        }];
    }];
    UINavigationController *workingNav = [[UINavigationController alloc] initWithRootViewController:workingListVC];
    
    BDKDumbListViewController *checkinVC = [[BDKDumbListViewController alloc] init];
    checkinVC.title = @"My Checkins";
    [checkinVC setRefreshBlock:^(void(^whenFinished)(NSArray *results)) {
       [self.untappd checkinsForUser:nil maxID:nil limit:10 completion:^(id responseObject, NSError *error) {
           whenFinished(responseObject);
       }];
    }];
    [checkinVC setCellDisplayBlock:^(BDKUntappdCheckin *checkin, UITableViewCell *cell) {
        cell.textLabel.text = checkin.beer.name;
        cell.detailTextLabel.text = checkin.beer.brewery.name;
    }];
    UINavigationController *checkinNav = [[UINavigationController alloc] initWithRootViewController:checkinVC];
    
    BDKDumbListViewController *friendsVC = [[BDKDumbListViewController alloc] init];
    friendsVC.title = @"Friends' Checkins";
    [friendsVC setRefreshBlock:^(void(^whenFinished)(NSArray *results)){
        [self.untappd checkinsForFriendsWithMaxID:nil limit:10 completion:^(id responseObject, NSError *error) {
            whenFinished(responseObject);
        }];
    }];
    [friendsVC setCellDisplayBlock:^(BDKUntappdCheckin *checkin, UITableViewCell *cell) {
        cell.textLabel.text = checkin.beer.name;
        cell.detailTextLabel.text = [checkin.user fullName];
    }];
    UINavigationController *friendNav = [[UINavigationController alloc] initWithRootViewController:friendsVC];
    
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[workingNav, checkinNav, friendNav];
    self.window.rootViewController = tabVC;
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
