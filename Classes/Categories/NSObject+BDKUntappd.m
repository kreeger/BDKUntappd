//
//  NSObject+BDKUntappd.m
//

#import "NSObject+BDKUntappd.h"

@implementation NSObject (BDKUntappd)

- (BOOL)bdk_isPresent {
    return ![self isEqual:[NSNull null]];
}

@end