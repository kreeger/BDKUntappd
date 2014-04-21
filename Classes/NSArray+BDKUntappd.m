//
//  NSArray+BDKUntappd.m
//

#import "NSArray+BDKUntappd.h"

@implementation NSArray (BDKUntappd)

- (NSArray *)bdkuntappd_map:(id (^)(id obj))eachObject {
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id result = eachObject(obj);
        if (!!result) [mArray addObject:obj];
    }];
    return [mArray copy];
}

@end
