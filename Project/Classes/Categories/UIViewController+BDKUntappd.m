//
//  UIViewController+BDKUntappd.m
//  BDKUntappd
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "UIViewController+BDKUntappd.h"

#import "BDKAppDelegate.h"

#import <BDKUntappd/BDKUntappd.h>

@implementation UIViewController (BDKUntappd)

- (BDKUntappd *)untappd {
    return [(BDKAppDelegate *)[[UIApplication sharedApplication] delegate] untappd];
}

@end
