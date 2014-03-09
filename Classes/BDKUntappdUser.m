//
//  BDKUntappdUser.m
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdUser.h"

@implementation BDKUntappdUser

#pragma mark - BDKUntappdModel

- (NSString *)remoteIdentifierName {
    return @"uid";
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, userName: %@, location: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.userName, self.location];
}

@end
