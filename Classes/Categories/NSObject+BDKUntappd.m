//
//  NSObject+BDKUntappd.m
//
//  Created by Ben Kreeger on 3/5/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "NSObject+BDKUntappd.h"

@implementation NSObject (BDKUntappd)

- (BOOL)bdk_isPresent {
    return ![self isEqual:[NSNull null]];
}

@end