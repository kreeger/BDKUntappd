//
//  BDKBeersViewController.m
//  BDKUntappd
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKBeersViewController.h"

#import "UIViewController+BDKUntappd.h"

#import <BDKUntappd/BDKUntappd.h>

@interface BDKBeersViewController ()

@end

@implementation BDKBeersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Recent Beers";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.untappd checkinsForUser:nil maxId:nil limit:5 completion:^(id responseObject, NSError *error) {
        NSLog(@"%@", responseObject);
    }];
}

@end
