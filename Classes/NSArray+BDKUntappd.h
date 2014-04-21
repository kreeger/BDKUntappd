//
//  NSArray+BDKUntappd.h
//

#import <Foundation/Foundation.h>

@interface NSArray (BDKUntappd)

- (NSArray *)bdkuntappd_map:(id (^)(id obj))eachObject;

@end
